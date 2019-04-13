# This is the abstract player class. This will contain most of the basic rules that
# are present for a player within the "Connect4" game
require 'Qt'
require 'test/unit'
require 'xmlrpc/utils'
require_relative '../board'
require_relative '../debug'

module Player
	class Abstract < Qt::Object
		include Test::Unit::Assertions
		include Debug

		# basic attributes
		attr_reader :name, :color

		# scores
		attr_accessor :wins, :losses, :ties

		# game data
		attr_accessor :host, :client, :goal, :model, :view
		
		# playing
		attr_reader :controller, :chip_model, :chip_view, :column

		slots :enable, :disable
		signals :finished

		public
		def initialize(player_name, player_color, parent: nil)
			parent != nil ? super(parent) : super()

			@name = player_name
			@wins = 0
			@losses = 0
			@ties = 0
			@color = Qt::Color.new(player_color)
			@host = false

			@controller = Board::Controller.new(parent: self)
		end

		def to_json(options={})
			return {
				'name' => @name,
				'wins' => @wins,
				'losses' => @losses,
				'ties' => @ties,
				'color' => @color.name,
				'goal' => @goal,
				'host' => @host
			}.to_json
		end

		def self.from_json(string)
			data = JSON.load string
			player = new data['name'], data['color']
			player.wins = data['wins']
			player.losses = data['losses']
			player.ties = data['ties']
			player.host = data['host']
			player.goal = data['goal']
			return player
		end

		def valid?()
			return false unless name.is_a?(String)
			return false unless host? == true or host? == false
			return false unless wins.is_a?(Integer) and @wins >= 0
			return false unless losses.is_a?(Integer) and @losses >= 0
			return false unless ties.is_a?(Integer) and @ties >= 0
			return false unless color.is_a?(Qt::Color)
			return true
		end

		def color=(c)
			@color = Qt::Color.new(c)
		end

		def enable(model)
			@model = model
			@view = client.view

			@chip_model = model.constructChip(self.color)
			@chip_view = Board::View::Chip.new(parent: self.client.view.board)
			@column = 0

			self.chip_view.update(self.chip_model)
			self.chip_view.geometry = client.view.board.head(self.column).geometry
			
			connect(self.controller, SIGNAL("dropped()"), self, SIGNAL("finished()"))
		end

		def disable()
			disconnect(self.controller, SIGNAL("dropped()"), self, SIGNAL("finished()"))
		end

		def drop()
			self.controller.drop(
				chip_model: self.chip_model, chip_view: self.chip_view,
				board_model: self.model.board, board_view: self.view.board,
				column: self.column, time: 750)
		end

		def left()
			return if self.column == 0

			controller.translate_model(
				item: self.chip_model,
				from: self.model.board.head(self.column),
				to:   self.model.board.head(self.column - 1))

			controller.translate_view(
				item: self.chip_view,
				from: self.view.board.head(self.column),
				to:   self.view.board.head(self.column - 1),
				time: 100)

			@column -= 1
		end

		def right()
			return if self.column == model.columns - 1

			controller.translate_model(
				item: self.chip_model,
				from: self.model.board.head(self.column),
				to:   self.model.board.head(self.column + 1))

			controller.translate_view(
				item: self.chip_view,
				from: self.view.board.head(self.column),
				to:   self.view.board.head(self.column + 1),
				time: 100)

			@column += 1
		end

		def up()
			@chip_model = self.model.constructChip(self.color, column: @column)
			self.view.board.head(@column).attached.text = @chip_model.text
			# self.model.board.head(@column).attach(@chip_model)
			# self.view.update(self.model)
		end

		def down()
			up()
		end

		def play()
			# This function will be implemented differently based on the player type
			raise AbstractClassError
		end
	end
end