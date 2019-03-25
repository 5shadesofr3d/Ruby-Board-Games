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
	EASY = 1
	NORMAL = 2
	HARD = 3

	attr_accessor :playing_game, :scoring_matrix, :ai_difficulty

	public
	def initialize(game, difficulty)
		# whenever the AI is initialized, it must have an instance of the game
		assert difficulty.is_a? Integer and difficulty > 0 and difficulty <= 3
		assert game.is_a? Game

		@scoring_matrix = []
		@playing_game = game
		@ai_difficulty = difficulty # 1, 2, 3

		assert @scoring_matrix.is_a? Array
	end

	def getBestScore(player_chip)
		# returns the columm that has the best score in terms of the difficulty

		# assert difficulty is valid
		# assert scoring matrix is not empty?? THIS IS PRONE TO CHANGE

		bestColumn = -1

		# TODO: implement the different values from the scoring matrix that are selected
		# If easy, use RNG
		if @ai_difficulty == EASY
			# return an RNG number within the bounds of the connect 4 game
			bestColumn = rand(self.playing_game.board.model.cols.max)
		elsif @ai_difficulty == MEDIUM
			# Get the first scoring layer from the current game and return the max of that
			self.get_score(player_chip)
			bestColumn = @scoring_matrix.each_with_index.max[1]
		elsif @ai_difficulty == HARD
			# Get the max scoring based off of the minimax algorithm
			self.minimax_alg(player_chip)
			bestColumn = @scoring_matrix.each_with_index.max[1]
		end

		# return the column number
		return bestColumn
	end


	private
	def scoring(temp_board, player_chip)
		# This is where the rules of the "scoring" of the game should go. This will be different
		# for every type of game that is created
		raise AbstractClassError
	end

	def get_score(player_chip)
		# This will be the general loop that will give the scoring matrix
		current_model = self.playing_game.board.model
		current_model.columns.each do |col|
			# get the next empty row num
			empty_row = 0
			# TODO: verify that this works
			e = current_model.to_enum(:each_in_column, :tile, col)
			e.reverse_each do |tile|
				if not tile.empty?
					empty_row += 1
				end
			end
			temp_board = self.playing_game.board.dup
			temp_board.drop(player_chip, col)
			score = scoring(temp_board, player_chip)
			self.scoring_matrix << score
		end
	end

	def minimax_alg(player_chip)
		# This is the main body of the algorithm that will be useful for if the difficulty is set to hard
		# assert difficulty is hard

		# TODO: Fill in the algorithm
		# run the algorithm. This is to be used in the scoring function

		# return values necessary in the scoring matrix
	end
end