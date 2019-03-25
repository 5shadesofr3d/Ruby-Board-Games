# This is the main AI for the OTTO TOOT game
require 'test/unit'
require_relative 'AI/ai_abstract'

class AI_OTTO < AI
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

		# check every column first for a "4 in a row"
	    model.columns.each do |col|
	      cols = model.to_enum(:each_in_column, :chip, col)
	      score += self.enum_score(cols)
	    end

	    # check every row
	    model.rows.each do |row|
	      rows = model.to_enum(:each_in_row, :chip, row)
	      score += self.enum_score(rows)
	    end

	    # check every diagonal
	    model.diagonals.each do |diagonal|
	      upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up, model.rows.max - 1, model.columns.max - 1)
	      score += self.enum_score(upper_diag)

	      lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down, model.rows.max - 1, model.columns.max - 1)
	      score += self.enum_score(lower_diag)
	    end

	    return score
	end

	def enum_score(iter)
		# returns that score based off of the rules
		method_score = 0
		iter.each_cons(4) { |chips| method_score += 100 if consecutive4?(chips) }
        iter.each_cons(4) { |chips| method_score += 5 if contain3?(chips) }
        iter.each_cons(4) { |chips| method_score += 2 if contain2?(chips) }
        iter.each_cons(4) { |chips| method_score -= 4 if block?(chips)}
        return method_score
    end

	def consecutive4?(chips)
		#TODO: Change these rules for OTTO
	    return false unless chips.size == 4
	    return false if chips.include?(nil)
	    return false unless chips.each {|c| c == @current_chip} # need to test this
	    return chips.uniq { |c| c.secondary }.length == 1
	end

	def contain2?(chips)
		# Checks to see if there are 2 without an enemy piece
		return false unless chips.size == 4
		return true if chips.count(@current_chip) == 2 and chips.count(nil) == 2
	end

	def contain3?(chips)
		# Checks to see if there are 3 without an enemy
		return false unless chips.size == 4
		return true if chips.count(@current_chip) == 3 and chips.count(nil) == 1
	end

	def block?(chips)
		# Checks to see if it should block an enemy because the enemy could win
		return false unless chips.size == 4
		return true if chips.count(nil) == 1 and chips.count{|c| c != @current_chip} >= 3
	end
end