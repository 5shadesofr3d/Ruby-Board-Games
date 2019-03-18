require 'test/unit'

class Board < Qt::Widget
	include Test::Unit::Assertions

	def initialize(rows, cols, width = 800, height = 600, parent = nil)
		if parent != nil
			super(parent)
		else
			super()
		end

		@tile = []

		@layout = Qt::GridLayout.new(self)
		@layout.setSpacing(0)
		self.setLayout(@layout)

		self.setWindowSize(width, height)
		self.setBoardSize(rows, cols)
		self.setWindowTitle("Ruby-Board-Games")
		self.move(100, 100)0

		assert self.valid?
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

		self.resize(width, height)

		assert self.width == width
		assert self.height == height
	end

	def setBoardSize(rows, cols)
		assert rows.is_a?(Integer) and rows.between?(1, 100)
		assert cols.is_a?(Integer) and cols.between?(1, 100)

		@rows = rows
		@cols = cols

		self.generateHead()
		self.generateTiles()

		assert self.valid?
	end

private
	def generateTiles()
		assert self.valid?
		assert @layout.count == @head.size

		@tile = []
		(0..@rows).each do |r|
			row = []
			(0..@cols).each do |c|
				item = BoardTile.new(parent: self)
				row << item
				@layout.addWidget(item, r + 1, c)
			end
			@tile << row
		end

		assert @layout.count == @head.size + @rows * @cols
		assert @tile.size == @rows
		assert @tile.first.size == @cols
		assert self.valid?
	end

	def generateHead()
		assert self.valid?
		assert @layout.isEmpty

		@head = []
		(0..@cols).each do |col|
			item = BoardHead.new(parent: self)
			@head << item
			@layout.addWidget(item, 0, col)
		end

		assert @layout.count == @head.size and @head.size == @cols
		assert self.valid?
	end

end