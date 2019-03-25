# This is the ai player that is available if the local player can play
# NOTE: The ai player instance will have an instance of the game, which
# 		has access to the board and the model
require 'test/unit'
require 'Qt'
require_relative 'abstract_player'
require_relative '../AI/ai_abstract'

class AIPlayer < Player

	def play(current_position, ai_type)
		# This will return the move that the player will take. This will come
		# from a move generator for the AI

		# The ai player will require the ai_type to be passed through
		# TODO: To be changed possibly based off of the main gameplay code. Look
		# 		into the player_lobby code

		#pre
		assert current_position.is_a? Numeric and current_position >= 0
		assert ai_type.is_a? AI
		# assert GameSettings.difficulty exists
		# assert AIMoveGenerator exists

		# AI will get the next position, will be determined based on the difficulty setting
		new_position = ai_type.getBestScore

		#post
		assert new_position.is_a? Numeric

		return new_position
	end
end