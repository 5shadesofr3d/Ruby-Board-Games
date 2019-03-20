require 'Qt'
require 'test/unit'

class BoardItem < Qt::Widget
	include Test::Unit::Assertions

	attr_accessor :primary, :secondary # colors

	def initialize(primary = Qt::transparent, secondary = Qt::transparent, parent = nil)
		parent != nil ? super(parent) : super()

		@primary = primary
		@secondary = secondary

		assert valid?
	end

	def valid?()
		return false unless @primary != nil
		return false unless @secondary != nil

		# Qt colors are enums, so potentially add assertions for interger type and ranges.

		return true
	end

	def paintEvent(event)
		assert valid?

		offset = 10
		circle_boundary = Qt::RectF.new(offset, offset, self.width - 2 * offset, self.height - 2 * offset)

		path = Qt::PainterPath.new
		path.addRect(0, 0, self.width, self.height)
		path.addEllipse(circle_boundary)

		brush_square = Qt::Brush.new(@primary)
		brush_circle = Qt::Brush.new(@secondary)

		painter = Qt::Painter.new(self)
		painter.setPen Qt::NoPen
		
		painter.setBrush brush_square
		painter.drawPath(path)

		painter.setBrush brush_circle
		painter.drawEllipse(circle_boundary)
		
		painter.end

		assert valid?
	end
end

class BoardTile < BoardItem
	def initialize(color = Qt::blue, parent = nil)
		super(color, Qt::transparent, parent)

		assert @primary == color
		assert valid?
	end

	def valid?()
		return false unless super
		return false unless @primary != Qt::transparent
		return false unless @secondary == Qt::transparent

		return true
	end
end

class BoardHead < BoardItem
	def initialize(parent = nil)
		super(Qt::transparent, Qt::transparent, parent)

		assert valid?
	end

	def valid?()
		return false unless super
		return false unless @primary == Qt::transparent
		return false unless @secondary == Qt::transparent

		return true
	end
end

class BoardChip < BoardItem
	def initialize(color = Qt::red, parent = nil)
		super(Qt::transparent, color, parent)

		assert @secondary == color
		assert valid?
	end

	def valid?()
		return false unless super
		return false unless @primary == Qt::transparent
		return false unless @secondary != Qt::transparent

		return true
	end
end