require 'Qt'
require 'test/unit'

module Board
	class View < Qt::Widget
		include Test::Unit::Assertions

		attr_accessor :text, :primary, :secondary # colors

		def initialize(primary: Qt::transparent, secondary: Qt::transparent, text: "", parent: nil)
			parent != nil ? super(parent) : super()

			assert primary != nil
			assert secondary != nil

			@text = text
			@primary = primary
			@secondary = secondary

			setStyleSheet("color: white;")

			show()

			assert valid?
		end

		def valid?()
			return false unless @text.is_a?(String)
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

			painter = Qt::Painter.new(self)
			rect = Qt::Rect.new(0, 0, self.width, self.height)
			font = painter.font()
			font.setPixelSize(32)
			painter.setFont(font)
			painter.drawText(rect, Qt::AlignCenter, @text)
			painter.end

			assert valid?
		end
	end
end