require 'test/unit'
require 'board'
require 'board_iterator'

class BoardModel
	# has the game logic for the board
	include Test::Unit::Assertions
	include BoardIterator

	def initialize(board)
		assert board.is_a?(Board)

		@board = board

		assert valid?
	end

	def initializeMatrix()
		@matrix = []
		@board.columns.each { |col| @matrix << [] }
	end

	def valid?()
		return false unless @board.is_a?(Board)
		return false unless @matrix.is_a?(Array)

		return true
	end

	def insert(chip, col)
		assert chip.is_a? BoardChip

		# connect insert signal with board insert-chip slot
	end

	def [](row, col)
		assert valid?

		return @matrix[col][row]
	end

end