require 'Qt'
require 'test/unit'
require_relative 'board/model'
require_relative 'board/view'
require_relative 'debug'

class Board < Qt::Widget
	include Test::Unit::Assertions
	include Debug

	attr_reader :model, :animation

	slots :onDrop
	signals :translateStarted, :translateCompleted, :dropped

	def initialize(rows, cols, width: 800, height: 600, parent: nil)
		parent != nil ? super(parent) : super()

		@model = BoardModel.new(rows, cols, parent: self)

		setupLayout()
		setupWindow(width, height)
		setupAnimation()

		assert valid?
	end

	def valid?
		return false unless @layout.is_a?(Qt::GridLayout)
		return false unless @model.is_a?(BoardModel)

		return true
	end

	def setupAnimation()
		@animation = Qt::PropertyAnimation.new(self)
		connect(animation, SIGNAL("finished()"), self, SIGNAL("translateCompleted()"))
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

	def clear()
		@model.each(:chip) {|chip| chip.deleteLater unless chip == nil }
		@model.each(:tile) {|tile| tile.detach }
	end

	def color=(c)
		@model.color = c
	end

	def drop(chip, col, time: 750)
		connect(self, SIGNAL("translateCompleted()"), self, SLOT("onDrop()"))
		translate(item: chip, from: model.head(col), to: model.next_empty(col), time: time)
	end

	def onDrop()
		dropped
		disconnect(self, SIGNAL("translateCompleted()"), self, SLOT("onDrop()"))
	end

	def translate(item: nil, from: nil, to: nil, time: 0)
		assert from.is_a?(BoardView)
		assert to.is_a?(BoardView)
		assert time.is_a?(Integer) and time >= 0

		from.detach()
		to.attach(item)

		return if from == to
		return if time == 0

		animation.targetObject = item
		animation.propertyName = "geometry"
		animation.duration = time
		animation.startValue = from.geometry
		animation.endValue = to.geometry

		translateStarted

		animation.start
	end

private


end
