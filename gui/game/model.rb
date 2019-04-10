require_relative '../board'
require_relative '../states/game_states'
require_relative '../debug'

module Game
	class Model::Abstract
		include Test::Unit::Assertions
		include Debug
		attr_reader :board_model, :board_controller
		attr_reader :lobby_model
		attr_reader :machine
		attr_reader :players

		def initialize(rows: 7, columns: 8)
			@players = {}
			@machine = GameStateMachine.new(self)
			@board_model = Board::Model.new(rows, columns)
			@board_controller = Board::Controller.new()
			@lobby_model = Lobby::Model.new()
		end

		def start()
			machine.setup()
			machine.start()
		end

		def constructChip(color, column: 0)
			raise NotImplementedError
		end

		def findGoal()
			# if a goal was found, we have a winner!
			assert board_model.is_a? Board::Model

			# check every column
			board_model.columns.each do |col|
				cols = model.to_enum(:each_in_column, :chip, col)
				cols.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
			end

			# check every row
			board_model.rows.each do |row|
				rows = model.to_enum(:each_in_row, :chip, row)
				rows.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
			end

			# check every diagonal
			board_model.diagonals.each do |diagonal|
				upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up)
				upper_diag.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
				lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down)
				lower_diag.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
			end

			return []
		end

		def winner?()
			return winnersGoal != nil
		end

		def tie?()
			topRow = board_model.to_enum(:each_in_row, :chip, 0)
			return (!topRow.include?(nil) and !winner?)
		end

		def winnersGoal()
			raise NotImplementedError
		end

		def matchesGoal?(chips)
			raise NotImplementedError
		end

		def setPlayerGoals()
			raise NotImplementedError
		end

		def updatePlayerScores()
			goal = winnersGoal
			if (goal != nil) # a winner was found
				players.each { |player| player.goal == goal ? player.wins += 1 : player.losses += 1 }
			else # we had a tie
				players.each { |player| player.ties += 1 }
			end
		end

		def updatePlayers()
			assert lobby.is_a? PlayerLobby

			@players = lobby_model.getPlayers()
			@players.each { |player| player.game = self }
			setPlayerGoals()

			assert @players.is_a? Array
			@players.each {|e| assert e.goal.is_a? Array}
			@players.each {|e| assert e.is_a? Player}
			assert @players.count > 0
		end

		def updatePlayerInfos()
			lobby_model.setPlayers(players)
			assert @lobby_model.getPlayers.count > 0
		end

		def addPlayer(player)
			assert Player.is_a?(Player)
			@players << player
			assert @players.include? player
		end
	end

	class Model::Connect4 < Model::Abstract
		def constructChip(color, column: 0)
			chip = Board::Model::Connect4Chip.new(color: color)
			return chip
		end

		def matchesGoal?(chips)
			assert chips.is_a? Array
			return false unless chips.size == 4
			return false if chips.include?(nil)
			return chips.uniq { |c| c.id }.length == 1
		end

		def setPlayerGoals()
			assert players.is_a? Array
			assert players.size > 0

			players.each { |player| player.goal = Array.new(4, player.color.name) }

			assert players.is_a? Array
			assert players.size > 0
			players.each {|p| assert p.goal.first == p.color.name}
			players.each {|p| assert p.goal.is_a? Array}
			players.each {|p| assert p.goal.size == 4}
		end

		def winnersGoal()
			chips = findGoal()
			players.each { |player| return player.goal if player.goal.size == chips.size && player.goal == chips.map(&:id) } # we have a winner if the chip sequence matches the player's goal
			return nil
		end
	end

	class Model::OTTO < Model::Abstract
		@@chip_iteration = 0
		@@otto = [:O, :T, :T, :O]
		@@toot = [:T, :O, :O, :T]

		def constructChip(color, column: 0)
			symbol = @@chip_iteration.even?() ? :T : :O
			chip = Board::Model::OTTOChip.new(id: symbol, color: color)
			@@chip_iteration += 1
			return chip
		end

		def matchesGoal?(chips)
			return false unless chips.size == 4
			return false if chips.include?(nil)
			return (chips.map(&:id) == @@otto or chips.map(&:id) == @@toot)
		end

		def winnersGoal()
			chips = findGoal()
			@players.each { |player| return player.goal if player.goal.size == chips.size && player.goal == chips.map(&:id) }
			return nil
		end

		def setPlayerGoals()
			@players.each_with_index { |player, index| player.goal = index.even? ? @@otto : @@toot }
		end
	end

end