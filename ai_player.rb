# This is the ai player that is available if the local player can play
require 'test/unit'
require_relative 'player_abstract'

class AIPlayer < Player

	def get_move
		# This will return the move that the player will take. This will come
		# from a move generator for the AI
	end
end