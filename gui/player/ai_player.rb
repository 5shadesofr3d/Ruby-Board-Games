# This is the ai player that is available if the local player can play
require 'test/unit'
require 'Qt'
require_relative 'player'

class AIPlayer < Player

	def get_move(current_position)
		# This will return the move that the player will take. This will come
		# from a move generator for the AI

		#pre
		assert current_position.is_a? Numeric and current_position >= 0
		# assert GameSettings.difficulty exists
		# assert AIMoveGenerator exists

		# AI will get the next position, will be determined based on the difficulty setting
		new_position = 1

		#post
		assert new_position.is_a? Numeric

		return new_position
	end
end