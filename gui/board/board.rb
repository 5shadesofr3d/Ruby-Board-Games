require 'Qt'
require 'test/unit'
require_relative 'board_iterator'
require_relative 'board_item'

class Board < Qt::Widget
	include Test::Unit::Assertions
	include BoardIterator

	def initialize(rows, cols, width = 800, height = 600, parent = nil)
		parent != nil ? super(parent) : super()

		@tile = []

		@layout = Qt::GridLayout.new(self)
		@layout.setSpacing(0)
		setLayout(@layout)

		setWindowSize(width, height)
		setBoardSize(rows, cols)
		setWindowTitle("Ruby-Board-Games")
		move(100, 100)
		show()

		assert valid?
	end

	def valid?
		return false unless @layout.is_a?(Qt::GridLayout)
		return false unless @tile.is_a?(Array) and @tile.size == @rows
		return false unless @rows.is_a?(Integer) and @rows > 0
		return false unless @cols.is_a?(Integer) and @cols > 0

		return true
	end

	def setWindowSize(width, height)
		assert width.is_a?(Integer) and width.between?(100, 1920)
		assert height.is_a?(Integer) and height.between?(100, 1080)

		resize(width, height)

		assert width() == width
		assert height() == height
	end

	def setBoardSize(rows, cols)
		assert rows.is_a?(Integer) and rows.between?(1, 100)
		assert cols.is_a?(Integer) and cols.between?(1, 100)

		@rows = rows 
		@cols = cols

		generateHead()
		generateTiles()

		assert valid?
	end

	def translate(item: nil, from: nil, to: nil, time: 0)
		assert from.is_a?(BoardItem)
		assert to.is_a?(BoardItem)
		assert time.is_a?(Integer) and time >= 0

		return if from == to

		animation = Qt::PropertyAnimation.new(self)
		animation.targetObject = item
		animation.propertyName = "geometry"
		animation.duration = time
		animation.startValue = from.geometry
		animation.endValue = to.geometry
		animation.start
	end

	def head(col)
		assert col.is_a?(Integer) and col.between?(columns)
		assert valid?

		return @head[col]
	end

	def tile(row, col)
		assert row.is_a?(Integer) and row.between?(rows)
		assert col.is_a?(Integer) and col.between?(columns)

		return @tile[row][col]
	end

	def background=(c)
		palette = Qt::Palette.new(c)
		setAutoFillBackground(true)
		setPalette(palette)
	end

	def color=(c)
		each { |tile| tile.primary = c }
	end

	def boardSize()
		return @rows * @cols
	end

private
	def generateTiles()
		assert @layout.count == @head.size

		@tile = []
		 rows.each do |r|
			row = []
			columns.each do |c|
				item = BoardTile.new(parent: self)
				row << item
				@layout.addWidget(item, r + 1, c)
			end
			@tile << row
		end

		assert @layout.count == @head.size + boardSize()
		assert @tile.size == @rows
		assert @tile.first.size == @cols
	end

	def generateHead()
		assert @layout.isEmpty

		@head = []
		columns.each do |col|
			item = BoardHead.new(parent: self)
			@head << item
			@layout.addWidget(item, 0, col)
		end

		assert @layout.count == @head.size and @head.size == @cols
	end

end