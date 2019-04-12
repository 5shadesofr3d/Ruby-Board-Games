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
require_relative '../board/iterator'

class AI
	include Test::Unit::Assertions
	EASY = 1
	NORMAL = 2
	HARD = 3

	attr_accessor :playing_game, :scoring_matrix, :ai_difficulty, :current_chip

	def initialize(game, difficulty, player_chip)
		# whenever the AI is initialized, it must have an instance of the game
		assert difficulty.is_a? Integer and difficulty > 0 and difficulty <= 3
		assert game.is_a? Game

		@scoring_matrix = []
		@playing_game = game
		@ai_difficulty = difficulty # 1, 2, 3
		@current_chip = player_chip

		assert @scoring_matrix.is_a? Array
	end

	def getBestScore
		# returns the columm that has the best score in terms of the difficulty

		# assert difficulty is valid
		# assert scoring matrix is not empty?? THIS IS PRONE TO CHANGE

		bestColumn = rand(self.playing_game.board.model.columns.max)

		# TODO: implement the different values from the scoring matrix that are selected
		# If easy, use RNG
		if @ai_difficulty == EASY
			# return an RNG number within the bounds of the connect 4 game
			# no change
		elsif @ai_difficulty == NORMAL
			# Get the first scoring layer from the current game and return the max of that
			self.get_score()
			bestColumn = @scoring_matrix.each_with_index.max[1]
		elsif @ai_difficulty == HARD
			# Get the max scoring based off of the minimax algorithm
			# NOTE: This part of the code is not implemented
			self.minimax_alg()
			bestColumn = @scoring_matrix.each_with_index.max[1]
		end

		# return the column number
		return bestColumn
	end

	def scoring(temp_board)
		# This is where the rules of the "scoring" of the game should go. This will be different
		# for every type of game that is created
		raise AbstractClassError
	end

	def get_score
		# This will be the general loop that will give the scoring matrix
		# TODO: Fix the changes made to the models in board to be used by the AI
		@current_chip.view.hide
		current_model = @playing_game.board.model
		current_model.columns.each do |col|
			# get the next empty row num
			score = 0
			empty_row = 0
			# TODO: verify that this works
			e = current_model.to_enum(:each_in_column, :tile, col)
			e.reverse_each do |tile|
				if not tile.empty?
					empty_row += 1
				end
			end
			begin
				tile = current_model.next_empty(col)
				if tile != nil
					# Do the mock translation
					@current_chip.view.geometry = tile.view.geometry
					puts "Making the fake move"
					@playing_game.board.translate(
						item: @current_chip,
						from: current_model.head(col),
						to: tile,
						time: 0)
					score = scoring(@playing_game.board, @current_chip)
					tile.detach()
				end

			rescue Board::Iterator::ColumnFullError
				# The column is full. Set the score to -100
				score = -100
			end
			# append the column score to the matrix
			@scoring_matrix << score
		end
		puts "showing the chip again"
		@current_chip.view.show
		@current_chip.update
	end

	def minimax_alg
		# This is the main body of the algorithm that will be useful for if the difficulty is set to hard
		# assert difficulty is hard
		# NOTE: This AI is assuming that there are only 2 players in the game.

		# TODO: Fill in the algorithm
		# run the algorithm. This is to be used in the scoring function

		# return values necessary in the scoring matrix

		# The following is the sudo code for the minimax function (coded in python)


		# def minimax(board, depth, alpha, beta, maximizingPlayer):
		# valid_locations = get_valid_locations(board)
		# is_terminal = is_terminal_node(board)
		# if depth == 0 or is_terminal:
		# 	if is_terminal:
		# 		if winning_move(board, AI_PIECE):
		# 			return (None, 100000000000000)
		# 		elif winning_move(board, PLAYER_PIECE):
		# 			return (None, -10000000000000)
		# 		else: # Game is over, no more valid moves
		# 			return (None, 0)
		# 	else: # Depth is zero
		# 		return (None, score_position(board, AI_PIECE))
		# if maximizingPlayer:
		# 	value = -math.inf
		# 	column = random.choice(valid_locations)
		# 	for col in valid_locations:
		# 		row = get_next_open_row(board, col)
		# 		b_copy = board.copy()
		# 		drop_piece(b_copy, row, col, AI_PIECE)
		# 		new_score = minimax(b_copy, depth-1, alpha, beta, False)[1]
		# 		if new_score > value:
		# 			value = new_score
		# 			column = col
		# 		alpha = max(alpha, value)
		# 		if alpha >= beta:
		# 			break
		# 	return column, value

		# else: # Minimizing player
		# 	value = math.inf
		# 	column = random.choice(valid_locations)
		# 	for col in valid_locations:
		# 		row = get_next_open_row(board, col)
		# 		b_copy = board.copy()
		# 		drop_piece(b_copy, row, col, PLAYER_PIECE)
		# 		new_score = minimax(b_copy, depth-1, alpha, beta, True)[1]
		# 		if new_score < value:
		# 			value = new_score
		# 			column = col
		# 		beta = min(beta, value)
		# 		if alpha >= beta:
		# 			break
		# 	return column, value


		# def is_terminal_node(board):
		# return winning_move(board, PLAYER_PIECE) or winning_move(board, AI_PIECE) or len(get_valid_locations(board)) == 0
	end
end