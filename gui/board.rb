require 'Qt'
require 'test/unit'
require_relative 'board/model'
require_relative 'board/view'
require_relative 'debug'

class Board < Qt::Widget
	include Test::Unit::Assertions
	include Debug
	
	attr_reader :model

	slots "insert(BoardView, int, int)"
	signals :insertComplete

	def initialize(rows, cols, width: 800, height: 600, parent: nil)
		parent != nil ? super(parent) : super()

		@model = BoardModel.new(rows, cols, parent: self)

		setupLayout()
		setupWindow(width, height)

		assert valid?
	end

	def valid?
		return false unless @layout.is_a?(Qt::GridLayout)
		return false unless @model.is_a?(BoardModel)

		return true
	end

	def setupLayout()
		@layout = Qt::GridLayout.new(self)
		@layout.setSpacing(0)
		setLayout(@layout)

		@model.each_with_index(:head) {|head, row, col| @layout.addWidget(head, row, col) }
		@model.each_with_index(:tile) {|tile, row, col| @layout.addWidget(tile, row + 1, col) }
	end

	def setupWindow(width, height)
		setWindowSize(width, height)
		setWindowTitle("Ruby-Board-Games")
		move(100, 100)
		show()
	end

	def setWindowSize(width, height)
		assert width.is_a?(Integer) and width.between?(100, 1920)
		assert height.is_a?(Integer) and height.between?(100, 1080)

		resize(width, height)

		assert width() == width
		assert height() == height
	end

	def background=(c)
		palette = Qt::Palette.new(c)
		setAutoFillBackground(true)
		setPalette(palette)
	end

	def color=(c)
		@model.color = c
	end

	def insert(chip, col, time: 1000)
		translate(item: chip, from: model.head(col), to: model.next_empty(col), time: time)
	end

private
	def translate(item: nil, from: nil, to: nil, time: 0)
		assert from.is_a?(BoardView)
		assert to.is_a?(BoardTile)
		assert time.is_a?(Integer) and time >= 0

		to.attach(item)

		return if from == to

		animation = Qt::PropertyAnimation.new(self)
		animation.targetObject = item
		animation.propertyName = "geometry"
		animation.duration = time
		animation.startValue = from.geometry
		animation.endValue = to.geometry
		connect(animation, SIGNAL("finished()"), self, SIGNAL(:insertComplete))
		animation.start
	end

end