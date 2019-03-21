# This is the abstract player class. This will contain most of the basic rules that
# are present for a player within the "Connect4" game
require 'Qt'
require 'test/unit'

class Player < Qt::Object
	include Test::Unit::Assertions

	attr_reader :name, :color
	attr_accessor :wins, :losses, :ties

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
		return false unless @name.is_a?(String)
		return false unless @wins.is_a?(Integer) and @wins >= 0
		return false unless @losess.is_a?(Integer) and @losses >= 0
		return false unless @ties.is_a?(Integer) and @ties >= 0
		return false unless @color.is_a?(Qt::Color)

		return true
	end

	def get_name
		return @name
	end

	def set_name(new_name)
		#pre
		assert new_name.is_a? String

		@name = new_name

		#post
		assert valid?
	end

	def total_score
		return wins - losses
	end

	def get_move
		# This function will be implemented differently based on the player type
		raise AbstractClassError
	end
end