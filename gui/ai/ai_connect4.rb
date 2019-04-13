# This is the main AI for the connect 4 game
require 'test/unit'
require_relative 'ai_abstract'

class AI_Connect4 < AI
	include Test::Unit::Assertions

	# implement the required scoring method
	def scoring(temp_board, player_piece)
		# takes in the instance of the game board and returns a scoring matrix
		# of size N x 1 (where N is the number of columns present in the game)
		score = 0
		model = temp_board
		#assert board.is_a? Board

		## Score center column
		center_array = model.to_enum(:each_in_column, :chip, (model.columns.max / 2).to_i)
		center_count = center_array.count(@current_chip)
		score += center_count * 3

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
	      upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up)
	      score += self.enum_score(upper_diag)

	      lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down)
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
        iter.each_cons(4) { |chips| method_score -= 4 if prevent_opp_win?(chips)}
        iter.each_cons(4) { |chips| method_score += 50 if block?(chips)}
        return method_score
    end

	def consecutive4?(chips)
	    return false unless chips.size == 4
	    return false if chips.include?(nil)
	    return false unless chips.each {|c| c == @current_chip} # need to test this
	    return chips.uniq { |c| c.id }.length == 1
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

	def prevent_opp_win?(chips)
		# Checks to see if it sets up the enemy to win
		return false unless chips.size == 4
		return true if chips.count(nil) == 1 and chips.count{|c| c != @current_chip and c != nil} >= 3
	end

	def block?(chips)
		# Checks to see if it should block the enemy
		return false unless chips.size == 4
		return true if chips.count{|c| c != @current_chip and c!= nil} == 3 and chips.count(@current_chip) == 1
	end

end