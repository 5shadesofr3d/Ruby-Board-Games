# This is the main AI for the OTTO TOOT game
require 'test/unit'
require_relative 'AI/ai_abstract'

class AI_OTTO < AI
	include Test::Unit::Assertions

	# implement the required scoring method
	def scoring(board)
		# takes in the instance of the game board and returns a scoring matrix
		# of size N x 1 (where N is the number of columns present in the game)

		#assert board.is_a? Board

		# TODO: set up the scoring algorithm and rules. Implement the MiniMax Algorithm

		# assert scoring_matrix > 1 and < N
	end
end