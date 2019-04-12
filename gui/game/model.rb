require_relative '../board'
require_relative '../debug'
require_relative '../lobby/model'
require_relative '../states/game_states'
require_relative 'saved_game'

module Game
	module Model
	class Abstract
		include Test::Unit::Assertions
		include Debug
		attr_reader :views
		attr_accessor :board
		attr_accessor :lobby


		def initialize(rows: 2, columns: 2)
			@views = []
			@players = {}
			@board = Board::Model.new(rows, columns)
			@lobby = Lobby::Model.new()
		end

		def saveToFile(fileName)
			file = File.open(fileName, 'w')
			file.puts self.to_json
			file.close
		end

		def to_json(options={})
			return {
				'class' => self.class,
				'board' => @board.to_json,
				'lobby' => @lobby.to_json
			}.to_json
		end

		def self.from_json(string)
			data = JSON.load string
			print(data)
			model = Object.const_get(data['class']).new
			model.board = Board::Model::from_json(data['board'])
			model.lobby = Lobby::Model::from_json(data['lobby'])
			return model
		end

		def addView(view)
			assert (view.is_a?(Game::View) or view.is_a?(Game::View::Proxy))
			@views << view
			board.addView view.board
			lobby.addView view.lobby
			view.show()
			notify()
		end

		def showLobby()
			views.each { |view| view.showLobby() }
		end

		def showBoard()
			views.each { |view| view.showBoard() }
		end

		def notify()
			views.each { |view| view.update(self) }
		end

		def start()
			machine.setup()
			machine.start()
		end

		def rows()
			return board.rowSize
		end

		def columns()
			return board.columnSize
		end

		def constructChip(color, column: 0)
			raise NotImplementedError
		end

		def players()
			return lobby.players
		end

		def findGoal()
			# if a goal was found, we have a winner!
			assert board.is_a? Board::Model

			# check every column
			board.columns.each do |col|
				cols = board.to_enum(:each_in_column, :chip, col)
				cols.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
			end

			# check every row
			board.rows.each do |row|
				rows = board.to_enum(:each_in_row, :chip, row)
				rows.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
			end

			# check every diagonal
			board.diagonals.each do |diagonal|
				upper_diag = board.to_enum(:each_in_diagonal, :chip, diagonal, :up)
				upper_diag.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
				lower_diag = board.to_enum(:each_in_diagonal, :chip, diagonal, :down)
				lower_diag.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
			end

			s = SavedGames.new()
			s.saveGame("GameTest", 1, self)

			return []
		end

		def winner?()
			return winnersGoal != nil
		end

		def tie?()
			topRow = board.to_enum(:each_in_row, :chip, 0)
			return (!topRow.include?(nil) and !winner?)
		end

		def winnersGoal()
			raise NotImplementedError
		end

		def matchesGoal?(chips)
			raise NotImplementedError
		end

		def initializePlayerGoals()
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
	end

	class Connect4 < Abstract
		def constructChip(color, column: 0)
			chip = Board::Model::Connect4Chip.new(color: color)
			views.each do |view|
				chip_view = Board::View::Chip.new(parent: view.board)
				chip.addView chip_view
				chip_view.geometry = view.board.head(column).geometry
			end			
			board.head(column).attach(chip)
			return chip
		end

		def matchesGoal?(chips)
			assert chips.is_a? Array
			return false unless chips.size == 4
			return false if chips.include?(nil)
			return chips.uniq { |c| c.id }.length == 1
		end

		def initializePlayerGoals()
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

	class OTTO < Abstract
		@@chip_iteration = 0
		@@otto = [:O, :T, :T, :O]
		@@toot = [:T, :O, :O, :T]

		def constructChip(color, column: 0)
			symbol = @@chip_iteration.even?() ? :T : :O
			chip = Board::Model::OTTOChip.new(id: symbol, color: color)
			views.each do |view|
				chip_view = Board::View::Chip.new(parent: view.board)
				chip.addView chip_view
				chip_view.geometry = view.board.head(column).geometry
			end
			board.head(column).attach(chip)
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
			players.each { |player| return player.goal if player.goal.size == chips.size && player.goal == chips.map(&:id) }
			return nil
		end

		def initializePlayerGoals()
			players.each_with_index { |player, index| player.goal = index.even? ? @@otto : @@toot }
		end
	end
	end
end