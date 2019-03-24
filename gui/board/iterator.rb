module BoardIterator

	def [](type, row, col)
		assert valid?
		assert row.is_a? Integer
		assert col.is_a? Integer
		assert row >= 0
		assert col >= 0
		assert valid_type?(type)

		case type
		when :head
			return head(col)
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

	def diagonals
		return (0..([@rows, @cols].min - 1))
	end

	def each(type)
		each_with_index(type) do |val, row, col|
			yield val
		end
	end

	def valid_type?(type)
		return (type.is_a?(Symbol) and (type == :tile or type == :chip or type == :head))
	end

	def each_with_index(type)
		assert valid?

		rows.each do |row|
			columns.each do |col|
				yield self[type, row, col], row, col
			end
			break if type == :head
		end

		assert valid?
	end

	def each_in_diagonal(type, diagonal, direction)
		assert diagonals.include?(diagonal)
		assert direction.is_a?(Symbol) and (direction == :up or direction == :down)
		assert valid_type?(type)

		(0..diagonal).each do |i|
			if direction == :up
				yield self[type, i, diagonal - i]
			elsif direction == :down
				yield self[type, diagonal - i, i]
			end
		end

		assert valid?
	end

	def each_in_row(type, row)
		assert valid?
		assert valid_type?(type)
		assert row.is_a? Integer
		assert row >= 0

		columns.each do |col|
			yield self[type, row, col]
		end

		assert valid?
	end

	def each_in_column(type, col)
		assert valid?
		assert valid_type?(type)

		rows.each do |row|
			yield self[type, row, col]
		end

		assert valid?
	end

	def next_empty(col)
		assert col.is_a? Integer
		assert col >= 0
		# iterates from bottom to top and returns the tile if its empty
		# returns nil if the selected col is full

		e = self.to_enum(:each_in_column, :tile, col)
		e.reverse_each { |tile| return tile if tile.empty? }

		raise ColumnFullError
	end

	class ColumnFullError < StandardError
	end

end
