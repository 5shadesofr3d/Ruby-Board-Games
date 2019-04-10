# This is the abstract player class. This will contain most of the basic rules that
# are present for a player within the "Connect4" game
require 'Qt'
require 'test/unit'
require_relative '../board'
require_relative '../debug'

class Player < Qt::Object
	include Test::Unit::Assertions
	include Debug

	attr_reader :name, :color, :current_chip
	attr_accessor :wins, :losses, :ties, :game, :current_column, :goal
	attr_accessor :host
	attr_reader :controller

	slots :enable, :disable
	signals :finished

	public
	def initialize(player_name, player_color, parent: nil)
		parent != nil ? super(parent) : super()
		# Set the name of the player and make the score 0
		#pre
		assert player_name.is_a? String
		#TODO: Player color

		@name = player_name
		@wins = 0
		@losses = 0
		@ties = 0
		@color = Qt::Color.new(player_color)
		@host = true

		@controller = Board::Controller.new(parent: self)

		#post
		assert @color.is_a? Qt::Color
		assert @name.is_a? String
		assert @name == player_name
		assert @wins >= 0 and @wins.is_a? Integer
		assert @losses >= 0 and @losses.is_a? Integer
		assert @ties >=0 and @ties.is_a? Integer
		assert valid?
	end

	def valid?
		return false unless name.is_a?(String)
		return false unless host? == true or host? == false
		return false unless wins.is_a?(Integer) and @wins >= 0
		return false unless losses.is_a?(Integer) and @losses >= 0
		return false unless ties.is_a?(Integer) and @ties >= 0
		return false unless color.is_a?(Qt::Color)
		return false unless game.is_a?(Game) or game == nil
		return true
	end

	def host?()
		return @host
	end

	def up()
		return if @current_chip == nil
		@current_chip.view = nil # deletes current view
		@current_chip = game.constructChip(color, column: @current_column)
	end

	def down()
		up()
	end

	def left()
		assert game.is_a? Game::Model::Abstract
		assert game.board.is_a? Board::Model

		return if current_column == 0

		model = game.board
		controller.translate(
			item: current_chip,
			from: model.head(current_column),
			to: model.head(current_column - 1),
			time: 100)

		@current_column -= 1

		assert @current_column.is_a? Integer
		assert game.is_a? Game::Model::Abstract
		assert game.board.is_a? Board::Model
	end

	def right
		assert game.is_a? Game::Model::Abstract
		assert game.board.is_a? Board::Model

		return if current_column == game.board.columns.max

		model = game.board
		controller.translate(
			item: current_chip,
			from: model.head(current_column),
			to: model.head(current_column + 1),
			time: 100)

		@current_column += 1

		assert @current_column.is_a? Integer
		assert game.is_a? Game::Model::Abstract
		assert game.board.is_a? Board::Model
	end

	def drop
		assert game.is_a? Game::Model::Abstract
		assert current_column.is_a? Integer
		assert current_column >= 0
		assert current_chip.is_a? Board::Model::Chip

		controller.drop(current_chip, current_column, game.board)
		@current_chip = nil

		assert @current_chip == nil
	end

	def enable
		assert game.is_a? Game::Model::Abstract
		assert game.board.is_a? Board::Model

		@current_chip = game.constructChip(color)
		@current_column = 0
		connect(controller, SIGNAL("dropped()"), self, SIGNAL("finished()"))

		assert @current_chip.is_a? Board::Model::Chip
		assert current_column.is_a? Integer and current_column >= 0
	end

	def disable()
		assert game.board.is_a? Board::Model
		disconnect(controller, SIGNAL("dropped()"), self, SIGNAL("finished()"))
	end

	def total_score
		assert wins.is_a? Integer
		assert losses.is_a? Integer
		assert wins >= 0
		assert losses >= 0

		return wins - losses
	end

	def play
		# This function will be implemented differently based on the player type
		raise AbstractClassError
	end
end
