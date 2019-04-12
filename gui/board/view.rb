require 'Qt'
require 'test/unit'
require_relative '../debug'

module Board
	class View < Qt::Widget
		include Test::Unit::Assertions
		include Board::Iterator

		def initialize(rows, cols, width: 800, height: 600, parent: nil)
			assert rows.is_a? Integer
			assert cols.is_a? Integer
			assert rows > 0
			assert cols > 0
			parent != nil ? super(parent) : super()

			@tile = []
			@head = []

			setupViews(rows, cols)
			setupLayout()
			setupWindow(width, height)

			assert valid?
		end

		def update(model)
			self.each_with_index(:head) { |head, row, col| head.update(model.head(col)) }
			self.each_with_index(:tile) { |tile, row, col| tile.update(model.tile(row, col)) }
		end

		def valid?
			return false unless @layout.is_a?(Qt::GridLayout) or @layout == nil
			return true
		end

		def setupViews(rows, cols)
			assert rows.is_a?(Integer) and rows.between?(1, 100)
			assert cols.is_a?(Integer) and cols.between?(1, 100)

			@rows = rows
			@cols = cols

			generateHead()
			generateTiles()

			assert valid?
		end

		def setupLayout()
			@layout = Qt::GridLayout.new(self)
			@layout.setSpacing(0)
			setLayout(@layout)

			self.each_with_index(:head) { |head, row, col| @layout.addWidget(head, row, col) }
			self.each_with_index(:tile) { |tile, row, col| @layout.addWidget(tile, row + 1, col) }
		end

		def setupWindow(width, height)
			setWindowSize(width, height)
			setWindowTitle("Ruby-Board-Games")
			move(100, 100)
			show()

			assert width() == width
			assert height() == height
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

	private
		def generateTiles()
			assert @tile.size == 0

			rows.each do |r|
				row = []
				columns.each do |c|
					item = Board::View::Tile.new(parent: self)
					row << item
				end
				@tile << row
			end

			assert @tile.size > 0
			assert @tile.size == @rows
			assert @tile.first.size == @cols
		end

		def generateHead()
			assert @head.size == 0

			columns.each do |col|
				item = Board::View::Tile.new(parent: self)
				@head << item
			end

			@head.size == @cols
		end
	end

	class View::Item < Qt::Widget
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

		def update(model)
			raise NotImplementedError
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

	class View::Tile < View::Item
		def empty?()
			return @attached.is_a?(NilClass)
		end

		def attach(chip)
			assert (chip.is_a?(Board::View::Chip) or chip.nil?)
			@attached = chip
		end

		def detach(destroy_view: true)
			@attached = nil
		end

		def update(model)
			self.primary = model.color
			self.secondary = Qt::transparent

			unless model.empty?
				self.attach(Board::View::Chip.new(parent: self.parent)) if self.empty?
				@attached.update( model.attached )
				@attached.geometry = self.geometry
			end
		end
	end

	class View::Chip < View::Item
		def update(model)
			self.primary = Qt::transparent
			self.secondary = model.color
			self.text = model.text
		end
	end

	class View::Proxy
    	include XMLRPC::Marshallable

		def initialize(username, port)
			@username = username
			@port = port
			@server = XMLRPC::Client.new("localhost", "/RPC2", port)
			@view = @server.proxy("#{@username}_board")
		end

		def head(column)
			return View::Tile::Proxy.new(@username, @port, column)
		end

		def tile(row, column)
			return View::Tile::Proxy.new(@username, @port, "#{row}_#{column}")
		end
	end

	class View::Tile::Proxy
		include XMLRPC::Marshallable
		
		def initialize(username, port, suffix)
			@username = username
			@column = column
			@port = port
			@server = XMLRPC::Client.new("localhost", "/RPC2", port)
			@view = @server.proxy("#{@username}_board_#{suffix}")
		end

		def update(model)
			@view.update(model)
		end
	end
end