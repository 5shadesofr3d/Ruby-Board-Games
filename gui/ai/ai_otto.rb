# This is the main AI for the OTTO TOOT game
require 'test/unit'
require_relative 'ai_abstract'

class AI_OTTO < AI
	include Test::Unit::Assertions

	attr_accessor :player_goal
	# NOTE: player goal is the result of what the player wants

	# implement the required scoring method
	def scoring(temp_board, player_piece)
		# takes in the instance of the game board and returns a scoring matrix
		# of size N x 1 (where N is the number of columns present in the game)
		score = 0
		model = temp_board.model
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
		iter.each_cons(4) { |chips| method_score += 100 if consecutiveOTTO?(chips) }
        iter.each_cons(4) { |chips| method_score += 5 if contain3?(chips) }
        iter.each_cons(4) { |chips| method_score += 2 if contain2?(chips) }
        iter.each_cons(4) { |chips| method_score -= 4 if prevent_opp_win?(chips)}
        return method_score
    end

	def consecutiveOTTO?(chips)
	    return false unless chips.size == 4
	    return false if chips.include?(nil)
	    return (chips.map(&:id) == @player_goal)
	end

	def contain2?(chips)
		# Checks to see if there are 2 without an enemy piece
		return false unless chips.size == 4
		(0..@player_goal.size-1).each do |i|
			temp_cons = @player_goal.dup
			temp_cons[i] = nil
			temp_cons[i+1] = nil
			if convertID(chips) == temp_cons
				return true
			end
		end
		return false
	end

	def contain3?(chips)
		# Checks to see if there are 3 without an enemy
		return false unless chips.size == 4
		(0..@player_goal.size-1).each do |i|
			temp_cons = @player_goal.dup
			temp_cons[i] = nil
			if convertID(chips) == temp_cons
				return true
			end
		end
		return false
	end

	def prevent_opp_win?(chips)
		# Checks to see if it sets up the enemy to win
		return false unless chips.size == 4
		temp_cons = @player_goal.dup
		(0..@player_goal.size).each do |i|
			if temp_cons[i] == :T
				temp_cons[i] = :O
			elsif temp_cons[i] == :O
				temp_cons[i] = :T
			end
		end

		(0..temp_cons.size-1).each do |i|
			temp_cons1 = temp_cons.dup
			temp_cons1[i] = nil
			if convertID(chips) == temp_cons1
				return true
			end
		end
		return false
	end

	def convertID(chips)
		return_array = []
		chips.each do |chip|
			if chip != nil
				return_array << chip.id
			else
				return_array << chip
			end
		end
		return return_array
	end

	# def block?(chips)
	# 	# Checks to see if it should block the enemy
	# 	return false unless chips.size == 4
	# 	return true if chips.count{|c| c != @current_chip and c!= nil} == 3 and chips.count(@current_chip) == 1
	# end
end