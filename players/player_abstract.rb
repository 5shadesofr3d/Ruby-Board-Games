# This is the abstract player class. This will contain most of the basic rules that
# are present for a player within the "Connect4" game
require 'test/unit'

class Player
	include Test::Unit::Assertions

	public
	def initialize(player_name)
		# Set the name of the player and make the score 0
		#pre
		assert player_name.is_a? String
		@name = player_name

		@score = 0

		#post
		assert valid?
	end

	def valid?
		assert @score.is_a? Numeric
		assert @name.is_a? String
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

	def get_score
		return @score
	end

	def scored
		# The player has won a game. Continue to add to their scoreboard
		@score = @score + 1

		#post
		assert valid?
	end

	def get_move
		# This function will be implemented differently based on the player type
		raise AbstractClassError
	end
end