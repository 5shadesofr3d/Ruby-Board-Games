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

		@name = player_name
		@wins = 0
		@losses = 0
		@ties = 0
		@color = Qt::Color.new(player_color)

		#post
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
		return if current_column == 0

		model = game.board.model
		game.board.translate(
			item: current_chip,
			from: model.head(current_column),
			to: model.head(current_column - 1),
			time: 100)
		
		@current_column -= 1
	end

	def right()
		return if current_column == game.board.model.columns.max

		model = game.board.model
		game.board.translate(
			item: current_chip,
			from: model.head(current_column),
			to: model.head(current_column + 1),
			time: 100)
		
		@current_column += 1
	end

	def drop()
		game.board.drop(current_chip, current_column)
		@current_chip = nil
	end

	def enable()
		@current_chip = game.constructChip(color)
		@current_column = 0
		connect(game.board, SIGNAL("dropped()"), self, SIGNAL("finished()"))
	end

	def disable()
		disconnect(game.board, SIGNAL("dropped()"), self, SIGNAL("finished()"))
	end

	def total_score
		return wins - losses
	end

	def play
		# This function will be implemented differently based on the player type
		raise AbstractClassError
	end
end