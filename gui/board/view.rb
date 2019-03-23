require 'Qt'
require 'test/unit'

class BoardView < Qt::Widget
	include Test::Unit::Assertions

	attr_accessor :primary, :secondary # colors

	def initialize(primary: Qt::transparent, secondary: Qt::transparent, parent: nil)
		parent != nil ? super(parent) : super()

		@primary = primary
		@secondary = secondary

		show()

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

		offset = 15
		circle_boundary = Qt::RectF.new(offset, offset, self.width - 2 * offset, self.height - 2 * offset)

		path = Qt::PainterPath.new
		path.addRect(0, 0, self.width, self.height)
		path.addEllipse(circle_boundary)

		brush_square = Qt::Brush.new(@primary)
		brush_circle = Qt::Brush.new(@secondary)

		painter = Qt::Painter.new(self)

		painter.setPen(Qt::NoPen)
		painter.setBrush(brush_square)
		painter.drawPath(path)
		painter.setBrush brush_circle
		painter.drawEllipse(circle_boundary)
		
		painter.end

		assert valid?
	end
end

class BoardTile < BoardView
	attr_reader :attached

	def initialize(color: Qt::blue, parent: nil)
		@attached = nil

		super(primary: color, secondary: Qt::transparent, parent: parent)

		assert @primary == color
		assert valid?
	end

	def valid?()
		return false unless super
		return false unless @secondary == Qt::transparent
		return false unless empty? or @attached.is_a?(BoardView)

		return true
	end

	def empty?()
		return @attached.is_a?(NilClass)
	end

	def resizeEvent(event)
		@attached.geometry = geometry() if not empty?
	end

	def attach(item)
		# attaching an item ensures that when the tile is resized, so is the attached item.
		# NOTE: attached items are treated like chips
		assert item.is_a?(BoardView)

		item.size = size()
		@attached = item

		assert valid?
	end

	def detach()
		@attached = nil
		assert valid?
	end

end

class BoardHead < BoardTile
	def initialize(parent: nil)
		super(color: Qt::transparent, parent: parent)

		assert valid?
	end

	def valid?()
		return false unless super
		return false unless @primary == Qt::transparent
		return false unless @secondary == Qt::transparent

		return true
	end

end

class BoardChip < BoardView
	def initialize(color: Qt::red, parent: nil)
		super(primary: Qt::transparent, secondary: color, parent: parent)

		lower() # place chip behind tiles

		assert @secondary == color
		assert valid?
	end

	def valid?()
		return false unless super
		return false unless @primary == Qt::transparent
		return false unless @secondary != Qt::transparent

		return true
	end

	def ==(chip)
		raise NotImplementedError
	end
end

class Connect4Chip < BoardChip
	def initialize(color: Qt::red, parent: nil)
		super(color: color, parent: parent)

		assert valid?
	end

	def ==(chip)
		return false if chip == nil
		# chips are equivalent if they are the same color:
		return self.secondary == chip.secondary
	end
end

class OTTOChip < BoardChip
	attr_reader :id

	def initialize(id, color: Qt::gray, parent: nil)
		assert id.is_a?(Symbol) and (id == :T or id == :O)

		@id = id

		super(color: color, parent: parent)		
		assert valid?
	end

	def valid?()
		return false unless super()
		return false unless @id.is_a?(Symbol) and (id == :T or id == :O)

		return true
	end

	def ==(chip)
		assert chip.is_a?(OTTOChip)
		
		# chips are equivalent if they have the same text (id):
		return self.id == chip.id
	end

	def paintEvent(event)
		super(event)

		rect = Qt::Rect.new(0, 0, width, height)

		painter = Qt::Painter.new(self)
		font = painter.font()
		font.setPixelSize(32)
		painter.setFont(font)
		id == :T ? painter.drawText(rect, Qt::AlignCenter, "T") : painter.drawText(rect, Qt::AlignCenter, "O")
		painter.end

		assert valid?
	end
end