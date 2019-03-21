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

	def diagonals
		return (0..[@rows, @cols].max - 1)
	end

	def each(type)
		self.each_with_index(type) do |val, row, col|
			yield val
		end
	end

	def valid_type?(type)
		return type.is_a?(Symbol) and (type == :tile or type == :chip)
	end

	def each_with_index(type)
		assert valid?
		assert valid_type?(type)

		rows.each do |row|
			columns.each do |col|
				yield self[type, row, col], row, col
			end
		end

		assert valid?
	end

	def each_in_diagonal(type, diagonal, direction)
		assert diagonal.between?(0, [@rows, @cols].min - 1)
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
		# iterates from bottom to top and returns the tile if its empty
		# returns nil if the selected col is full

		e = self.to_enum(:each_in_column, :title, col)
		e.reverse.each { |tile| return tile if tile.empty? }

		return nil
	end

end