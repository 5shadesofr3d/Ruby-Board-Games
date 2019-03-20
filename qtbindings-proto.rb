
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

	signals :sizeChanged

	def initialize(parent, color_square = Qt::green, color_circle = Qt::transparent)
		super(parent)

		@color_square = color_square
		@color_circle = color_circle
		@in_use = false
	end

	def resizeEvent(event)
		# puts "#{self.x} #{self.y} #{self.width} #{self.height}"
		self.sizeChanged
	end

	def in_use?()
		return @in_use
	end

	def paintEvent(event)
		offset = 10
		circle_boundary = Qt::RectF.new(offset, offset, self.width - 2 * offset, self.height - 2 * offset)

		path = Qt::PainterPath.new
		path.addRect(0, 0, self.width, self.height)
		path.addEllipse(circle_boundary)

		brush_square = Qt::Brush.new(@color_square)
		brush_circle = Qt::Brush.new(@color_circle)

		painter = Qt::Painter.new(self)
		painter.setPen Qt::NoPen

		painter.setBrush brush_square
		painter.drawPath(path)

		painter.setBrush brush_circle
		painter.drawEllipse(circle_boundary)

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
		for i in 0..@rows - 1
			row = []
			for j in 0..@columns - 1
				row << BoardItem.new(parent)
			end
			@matrix << row
		end
	end

	def each()
		for i in 0..@rows - 1
			for j in 0..@columns - 1
				yield self[i, j]
			end
		end
	end

	def each_with_index()
		for i in 0..@rows - 1
			for j in 0..@columns - 1
				yield self[i, j], i, j
			end
		end
	end

	def each_in_row(i)
		for j in 0..@columns - 1
			yield self[i, j]
		end
	end

	def each_in_column(j)
		for i in 0..@rows - 1
			yield self[i, j]
		end
	end

	def tail(j)
		for i in ((@rows - 1) ..0)
			return self[i, j] if not self[i, j].in_use?
		end
		return self[6, 0]
	end

	def [](i, j)
		return @matrix[i][j]
	end

end

class Board < Qt::Widget

	def initialize(rows, columns, width = 800, height = 600)
		super()

		@head = BoardMatrix.new(self, 1, columns)
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

		@head.each_with_index { |item, row, column|
			@layout.addWidget(item, row, column)
			item.color_square = Qt::transparent
		}

		@matrix.each_with_index { |item, row, column|
			@layout.addWidget(item, row + 1, column)
		}

		# test_painter()
		test_drop

		setLayout @layout
	end

	slots :drop

	def test_drop
		head = @head[0, 0]
		connect(head, SIGNAL(:sizeChanged), self, SLOT(:drop))
	end

	def drop()
		column = 0
		@item = BoardItem.new(self, Qt::transparent, Qt::red)
		head = @head[0, column]
		tail = @matrix.tail(column)
		@item.lower
		@item.show
		# @item.setGeometry head.geometry
		puts "#{@item.x} #{@item.y} #{@item.width} #{@item.height}"

		@animation = Qt::PropertyAnimation.new
		@animation.targetObject = @item
		@animation.propertyName = "geometry"
		@animation.duration = 2000
		@animation.startValue = head.geometry
		@animation.endValue = tail.geometry
		@animation.start
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
