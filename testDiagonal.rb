class BoardModel

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
		return (0..(([@rows, @cols].min) * 2) - 2)
	end

  def each_in_diagonal(diagonal, direction, max)

		(0..diagonal).each do |i|
      if direction == 1
        if i <= max and diagonal - i <= max
				  yield [i, diagonal - i]
        end
			elsif direction == 2
        if i <= max and max - diagonal + i >= 0
				  yield [i, max - diagonal + i]
        end
			end

    end

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
      cols = self.to_enum(:each_in_column, col)
      cols.each do |c|
        print(c)
        print("\n")
      end
      print("\n")
      print("\n")
    end

    # check every row
    self.rows.each do |row|
      rows = self.to_enum(:each_in_row, row)
      rows.each do |r|
        print(r)
        print("\n")
      end
      print("\n")
      print("\n")
    end

    # check every diagonal
    self.diagonals.each do |diagonal|
      upper_diag = self.to_enum(:each_in_diagonal, diagonal, 1, [@rows, @cols].min - 1)
      upper_diag.each do |u|
        print(u)
        print("\n")
      end
      print("\n")
      print("\n")

      lower_diag = self.to_enum(:each_in_diagonal, diagonal, 2, [@rows, @cols].min - 1)
      lower_diag.each do |d|
        print(d)
        print("\n")
      end
      print("\n")
      print("\n")
    end


  end

end
