
# INSTALLATION:
#
# 1. sudo aptitude install build-essential bison openssl libreadline5 \
# 		libreadline-dev curl git-core zlib1g zlib1g-dev libssl-dev vim \
# 		libsqlite3-0 libsqlite3-dev sqlite3 \
# 		libxml2-dev git-core subversion autoconf xorg-dev libgl1-mesa-dev \
# 		libglu1-mesa-dev
#
# 2. sudo apt-get install libqt4-dev
#
# 3. sudo gem install qtbindings

require 'Qt'

class BoardItem < Qt::Widget

	attr_accessor :color_square, :color_circle
	attr_writer :in_use

	def initialize(parent, color_square = Qt::green, color_circle = Qt::transparent)
		super(parent)

		@color_square = color_square
		@color_circle = color_circle
		@in_use = false
	end

	def in_use?()
		return @in_use
	end

	def paintEvent(event)
		painter = Qt::Painter.new(self)

		brush_circle = Qt::Brush.new(color_circle)
		brush_square = Qt::Brush.new(color_square)

		painter.setPen Qt::NoPen

		painter.setBrush brush_square
		painter.drawRect(0, 0, self.width, self.height)

		center = Qt::Point.new(self.width/2, self.height/2)
		radius = self.width/2 - 15
		painter.setBrush brush_circle
		painter.drawEllipse(center, radius, radius)

		painter.end
	end

end

class BoardMatrix
	attr_accessor :rows, :columns, :matrix

	def initialize(parent, rows, columns)
		@rows = rows
		@columns = columns

		initialize_matrix(parent)
	end

	def initialize_matrix(parent)
		@matrix = [] # array of array
		for i in 0..@rows-1
			row = []
			for j in 0..@columns-1
				row << BoardItem.new(parent)
			end
			@matrix << row
		end
	end

	def each()
		for i in 0..@rows-1
			for j in 0..@columns-1
				yield self[i, j]
			end
		end
	end

	def each_with_index()
		for i in 0..@rows-1
			for j in 0..@columns-1
				yield self[i, j], i, j
			end
		end
	end

	def each_in_row(i)
		for j in 0..@columns-1
			yield self[i, j]
		end
	end

	def each_in_column(j)
		for i in 0..@rows-1
			yield self[i, j]
		end
	end

	def [](i, j)
		return @matrix[i][j]
	end

end

class Board < Qt::Widget

	def initialize(rows, columns, width = 800, height = 600)
		super()

		@matrix = BoardMatrix.new(self, rows, columns)

		setWindowTitle "Ruby-Board-Games"
		resize width, height
		move 100, 100

		setup_ui

		show
	end

	def setup_ui()
		@layout = Qt::GridLayout.new(self)
		@layout.setSpacing(0)

		@matrix.each_with_index do |item, row, column|
			@layout.addWidget(item, row, column)			
		end

		test_painter()

		setLayout @layout
	end

	def drop(column)

	end

	def test_painter()
		@matrix.each_in_row(6) do |item|
			if rand < 0.5
				item.color_circle = Qt::red
			else
				item.color_circle = Qt::yellow
			end
		end

		@matrix.each_in_row(5) do |item|
			if rand < 0.5
				item.color_circle = Qt::red
			else
				item.color_circle = Qt::yellow
			end
		end

		@matrix.each_in_row(4) do |item|
			if rand < 0.5
				item.color_circle = Qt::red
			else
				item.color_circle = Qt::yellow
			end
		end
	end

end

app = Qt::Application.new ARGV
board = Board.new(7, 8)
app.exec