module BoardIterator
	def each()
		assert valid?

		self.each_with_index() do |val, row, col|
			yield val
		end

		assert valid?
	end

	def each_with_index()
		assert valid?

		(0..@rows).each do |row|
			(0..@cols).each do |col|
				yield self[row, col], row, col
			end
		end

		assert valid?
	end

	def each_in_row(row)
		assert valid?

		(0..@cols).each do |col|
			yield self[row, col]
		end

		assert valid?
	end

	def each_in_column(col)
		assert valid?

		(0..@rows).each do |row|
			yield self[row, col]
		end

		assert valid?
	end

	def [](row, col)
		assert valid?
		assert row.is_a?(Integer) and row.between?(0, @rows)
		assert col.is_a?(Integer) and col.between?(0, @cols)

		return @tile[row][col]
	end

end