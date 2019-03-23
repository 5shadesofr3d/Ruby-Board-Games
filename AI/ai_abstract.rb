# This is the abstract class for the AI algorithm.

# Things to keep of note.

# AI machine for each game type may be seperate but come from an abstract AI class.

# The AI class will have the following methods:
# initialize (private)
# scoring (private) <- this sets the rules and will be implemented in the inherited classes. Returns array of score
# getBestScore (public)
# minimax algorithm body (private)

# This will be the basis of the AI. I will need to set the scoring individually for each of the AI instances for any new game mode (both connect 4 and otto).
# Once that is good they will all run the same getBestScore (based on difficulty) and return the corresponding column number as if it was its own move
require 'test/unit'

class AI
	include Test::Unit::Assertions

	public
	def initialize
		@scoring_matrix = []
	end

	def getBestScore(difficulty)
		# returns the columm that has the best score in terms of the difficulty

		# assert difficulty is valid

		# TODO: implement the different values from the scoring matrix that are selected
		# If easy, use RNG
		# If medium, only get the first level matrix
		# If hard, get the max score

		# return the column number
	end


	private
	def scoring(board)
		# This is where the rules of the "scoring" of the game should go. This will be different
		# for every type of game that is created
		raise AbstractClassError
	end

	def minimax_alg
		# This is the main body of the algorithm that will be useful for if the difficulty is set to hard
		# assert difficulty is hard

		# run the algorithm. This is to be used in the scoring function

		# return values necessary in the scoring matrix
	end
end