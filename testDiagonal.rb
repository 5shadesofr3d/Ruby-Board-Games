class BoardModel
	include Test::Unit::Assertions

	attr_reader :parent

	def initialize(rows, cols, parent: nil)

		@parent = parent

		@tile = []
		@head = []

    setBoardSize(rows, cols)

	end

	def setBoardSize(rows, cols)

		@rows = rows
		@cols = cols

	end

  def rows
		return (0..@rows-1)
	end

	def columns
		return (0..@cols-1)
	end

  def diagonals
		return (0..([@rows, @cols].min - 1))
	end

  def each_in_diagonal(type, diagonal, direction)

		(0..diagonal).each do |i|
			if direction == 1
				yield [i, diagonal - i]
			elsif direction == 2
				yield [diagonal - i, i]
			end
		end

		assert valid?
	end

	def each_in_row(row)

		columns.each do |col|
			yield [row, col]
		end

	end

	def each_in_column(col)

		rows.each do |row|
			yield [row, col]
		end

	end

  def findConsecutive4()

    # check every column first for a "4 in a row"
    self.columns.each do |col|
      cols = model.to_enum(:each_in_column, col)
      cols.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    # check every row
    model.rows.each do |row|
      rows = model.to_enum(:each_in_row, row)
      rows.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    # check every diagonal
    model.diagonals.each do |diagonal|
      upper_diag = model.to_enum(:each_in_diagonal, diagonal, 1)
      print(upper_diag)

      lower_diag = model.to_enum(:each_in_diagonal, diagonal, 2)
      lower_diag.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    assert valid?
  end

end
