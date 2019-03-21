module BoardIterator

	def [](type, row, col)
		assert valid?
		assert type.is_a?(Symbol) and (type == :tile or type == :chip)

		case type
		when :tile
			return tile(row, col)
		when :chip
			return chip(row, col)
		end
	end

	def rows
		return (0..@rows-1)
	end

	def columns
		return (0..@cols-1)
	end

	def each(type)
		assert valid?

		self.each_with_index(type) do |val, row, col|
			yield val
		end

		assert valid?
	end

	def each_with_index(type)
		assert valid?
		assert type.is_a?(Symbol) and (type == :tile or type == :chip)

		rows.each do |row|
			columns.each do |col|
				yield self[type, row, col], row, col
			end
		end

		assert valid?
	end

	def each_along_diagonal_up(type, diagonal)
		columns.each do |col|

		end
	end

	def each_in_row(type, row)
		assert valid?

		columns.each do |col|
			yield self[type, row, col]
		end

		assert valid?
	end

	def each_in_column(type, col)
		assert valid?

		rows.each do |row|
			yield self[type, row, col]
		end

		assert valid?
	end

end