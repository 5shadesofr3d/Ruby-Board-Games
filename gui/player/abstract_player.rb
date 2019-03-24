# This is the abstract player class. This will contain most of the basic rules that
# are present for a player within the "Connect4" game
require 'Qt'
require 'test/unit'
require_relative '../debug'

class Player < Qt::Object
	include Test::Unit::Assertions
	include Debug

	attr_reader :name, :color, :current_chip
	attr_accessor :wins, :losses, :ties, :game, :current_column

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
		return false unless wins.is_a?(Integer) and @wins >= 0
		return false unless losses.is_a?(Integer) and @losses >= 0
		return false unless ties.is_a?(Integer) and @ties >= 0
		return false unless color.is_a?(Qt::Color)
		return false unless game.is_a?(Game) or game == nil
		return true
	end

	def left()
		assert game.is_a? Game
		assert game.board.model.is_a? BoardModel

		return if current_column == 0

		model = game.board.model
		game.board.translate(
			item: current_chip,
			from: model.head(current_column),
			to: model.head(current_column - 1),
			time: 100)

		@current_column -= 1

		assert @current_column.is_a? Integer
		assert game.is_a? Game
		assert game.board.model.is_a? BoardModel
	end

	def right()
		assert game.is_a? Game
		assert game.board.model.is_a? BoardModel

		return if current_column == game.board.model.columns.max

		model = game.board.model
		game.board.translate(
			item: current_chip,
			from: model.head(current_column),
			to: model.head(current_column + 1),
			time: 100)

		@current_column += 1

		assert @current_column.is_a? Integer
		assert game.is_a? Game
		assert game.board.model.is_a? BoardModel
	end

	def drop()
		assert game.is_a? Game
		assert current_column.is_a? Integer
		assert current_column >= 0
		assert current_chip.is_a? BoardChip

		game.board.drop(current_chip, current_column)
		@current_chip = nil

		assert @current_chip == nil
	end

	def enable()
		assert game.is_a? Game
		assert game.board.is_a? Board

		@current_chip = game.constructChip(color)
		@current_column = 0
		connect(game.board, SIGNAL("dropped()"), self, SIGNAL("finished()"))

		assert @current_chip.is_a? BoardChip
		assert current_column.is_a? Integer and current_column >= 0
	end

	def disable()
		assert game.board.is_a? Board

		disconnect(game.board, SIGNAL("dropped()"), self, SIGNAL("finished()"))
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
