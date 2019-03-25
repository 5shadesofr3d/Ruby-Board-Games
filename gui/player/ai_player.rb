# This is the ai player that is available if the local player can play
# NOTE: The ai player instance will have an instance of the game, which
# 		has access to the board and the model
require 'test/unit'
require 'Qt'
require_relative 'abstract_player'
require_relative '../AI/ai_abstract'

class AIPlayer < Player

	def play(ai_type)
		# This will return the move that the player will take. This will come
		# from a move generator for the AI
		ai_test = AI_Connect4.new(self.game, 1)
		# The ai player will require the ai_type to be passed through
		# TODO: To be changed possibly based off of the main gameplay code. Look
		# 		into the player_lobby code

		#pre
		assert game.is_a?(Game)
		assert event.is_a?(Qt::KeyEvent) or event.is_a?(Qt::MouseEvent)

		# AI will get the next position, will be determined based on the difficulty setting
		new_position = ai_test.getBestScore(current_chip)
		puts new_position
		drop()

		#post
		assert current_column.is_a?(Numeric)

		return new_position
	end
end