# This is the main AI for the connect 4 game
require 'test/unit'
require_relative 'AI/ai_abstract'

class AI_Connect4 < AI
	include Test::Unit::Assertions

	# implement the required scoring method
	def scoring(temp_board, player_piece)
		# takes in the instance of the game board and returns a scoring matrix
		# of size N x 1 (where N is the number of columns present in the game)
		score = 0
		model = temp_board.model
		#assert board.is_a? Board

		# TODO: set up the scoring algorithm and rules. Implement the MiniMax Algorithm

		# assert scoring_matrix > 1 and < N
		# check every column first for a "4 in a row"

		# check vertically
	    model.columns.each do |col|
	      cols = model.to_enum(:each_in_column, :chip, col)
	      cols.each_cons(4) { |chips| score += 100 if consecutive4?(chips) }
	    end

	    # check every row
	    model.rows.each do |row|
	      rows = model.to_enum(:each_in_row, :chip, row)
	      rows.each_cons(4) { |chips| score += 100 if consecutive4?(chips) }
	    end

	    # check every diagonal
	    model.diagonals.each do |diagonal|
	      upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up)
	      upper_diag.each_cons(4) { |chips| score += 100 if consecutive4?(chips) }

	      lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down)
	      lower_diag.each_cons(4) { |chips| score += 100 if consecutive4?(chips) }
	    end

	    return score
	end

	def consecutive4?(chips)
	    return false unless chips.size == 4
	    return false if chips.include?(nil)
	    return chips.uniq { |c| c.secondary }.length == 1
	end

	def contain2?(tiles)
		# Checks to see if there are 2 without an enemy piece
	end

	def contain3?(tiles)
		# Checks to see if there are 3 without an enemy
	end

	def block?(tiles)
		# Checks to see if it should block an enemy
	end

end