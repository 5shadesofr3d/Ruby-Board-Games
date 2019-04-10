require 'Qt'
require 'test/unit'
require 'chroma'
require_relative 'iterator'
require_relative 'view'
require_relative '../debug'

module Board
	class Model
		include Test::Unit::Assertions
		include Board::Iterator
		include Debug

		def initialize(rows, cols)
			assert rows.is_a? Integer
			assert cols.is_a? Integer
			assert rows > 0
			assert cols > 0

			@tile = []
			@head = []

			setBoardSize(rows, cols)

			assert valid?
		end

		def valid?
			return false unless @tile.is_a?(Array) and @tile.size == @rows
			return false unless @rows.is_a?(Integer) and @rows > 0
			return false unless @cols.is_a?(Integer) and @cols > 0

			return true
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

		def addView(view)
			assert view.is_a? (Board::View)
			self.each_with_index(:head) { |head, row, col| head.addView view.head(col) }
			self.each_with_index(:tile) { |tile, row, col| tile.addView view.tile(row, col) }
		end

		def color=(c)
			each(:tile) { |tile| tile.color = c }
		end

		def boardSize()
			return @rows * @cols
		end

		def notify()
			each(:head) { |head| head.notify() }
			each(:tile) { |tile| tile.notify() }
		end

		def rowSize()
			return @rows
		end

		def columnSize()
			return @cols
		end

	private
		# Takes values of format: rgb(X, X, X) and
		# outputs a Qt color
		def rgbString_to_QtColor(input)
			Qt::Color.fromRgb(
				input.paint.rgb.r,
				input.paint.rgb.g,
				input.paint.rgb.b)
		end

		def generateTiles()
			assert @tile.size == 0

			theme = Settings.instance.theme
			tile_color = rgbString_to_QtColor(theme.color[:tile_color])

			rows.each do |r|
				row = []
				columns.each do |c|
					item = Board::Model::Tile.new(color: tile_color)
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
				item = Board::Model::Tile.new(color: Qt::transparent)
				@head << item
			end

			@head.size == @cols
		end
	end

	class Model::Tile
		include Test::Unit::Assertions
		include Debug
		attr_reader :views, :attached
		attr_accessor :color

		def initialize(color: Qt::transparent, view: nil)
			@color = color
			@views = []
		end

		def attach(chip)
			assert chip.is_a?(Board::Model::Chip)
			@attached = chip
			notify()
		end

		def detach(destroy_view: true)
			if destroy_view and attached != nil 
				attached.views.each { |view| view.deleteLater() if attached.view != nil}
			end
			@attached = nil
			notify()
		end

		def empty?()
			return @attached.is_a?(NilClass)
		end

		def addView(view)
			assert (view.is_a?(Board::View::Item))
			@views << view
			notify()
		end

		def notify()
			views.each do |view|
				view.update(self)
			end

			attached.notify() unless empty?
		end
	end

	class Model::Chip
		include Test::Unit::Assertions
		include Debug
		attr_reader :views, :color, :text
		attr_accessor :id

		def initialize(id: nil, color: Qt::red, view: nil)
			@text = ""
			self.id = id
			self.color = Qt::Color.new(color)
			@views = []
		end

		def addView(view)
			assert (view.is_a?(Board::View::Item))
			@views << view
			view.lower()
			notify()
		end

		def color=(value)
			assert value.is_a?(Qt::Color)
			@color = value
		end

		def notify()
			views.each { |view| view.update(self) }
		end
	end

	class Model::Connect4Chip < Board::Model::Chip
		def initialize(color: Qt::red, view: nil)
			super(id: color, color: color, view: view)
			@id = color.name
		end

		def color=(value)
			super(value)
			@id = color.name
		end
	end

	class Model::OTTOChip < Board::Model::Chip
		def initialize(id: :T, color: Qt::red, view: nil)
			assert (id == :T or id == :O)
			super(id: id, color: color, view: view)
		end

		def id=(value)
			assert (value == :T or value == :O)
			@id = value
			@text = @id.to_s
		end
	end

end