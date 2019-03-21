module BoardIterator

	def rows
		return (0..@rows-1)
	end

	def columns
		return (0..@cols-1)
	end

	def each()
		assert valid?

		self.each_with_index() do |val, row, col|
			yield val
		end

		assert valid?
	end

	def each_with_index()
		assert valid?

		rows.each do |row|
			columns.each do |col|
				yield self[row, col], row, col
			end
		end

		assert valid?
	end

	def each_in_row(row)
		assert valid?

		columns.each do |col|
			yield self[row, col]
		end

		assert valid?
	end

	def each_in_column(col)
		assert valid?

		rows.each do |row|
			yield self[row, col]
		end

		assert valid?
	end

end