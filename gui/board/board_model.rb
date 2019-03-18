require 'test/unit'

class BoardModel
	include Test::Unit::Assertions

	def initialize()

	end

	def insertChip(chip)
		assert chip.is_a? BoardChip

		# connect insert signal with board insert-chip slot
	end

end