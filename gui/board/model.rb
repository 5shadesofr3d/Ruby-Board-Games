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

		attr_reader :view

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

		def view?()
			return @view.is_a?(Board::View)
		end

		def view=(view)
			assert (view.is_a? (Board::View) or view == nil)
			@view = view
			if view?
				self.each_with_index(:head) { |head, row, col| head.view = view.head(col) }
				self.each_with_index(:tile) { |tile, row, col| tile.view = view.tile(row, col) }
			end
			notify()
		end

		def color=(c)
			each(:tile) { |tile| tile.color = c }
		end

		def boardSize()
			return @rows * @cols
		end

		def notify()
			return unless view?

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
		attr_reader :view, :attached
		attr_accessor :color

		def initialize(color: Qt::transparent, view: nil)
			@color = color
		end

		def attach(chip)
			assert chip.is_a?(Board::Model::Chip)
			@attached = chip
			notify()
		end

		def detach(destroy_view: true)
			attached.view.deleteLater() if destroy_view and attached != nil and attached.view != nil
			@attached = nil
			notify()
		end

		def empty?()
			return @attached.is_a?(NilClass)
		end

		def view?()
			return view.is_a?(Board::View::Item)
		end

		def view=(view)
			assert (view.is_a?(Board::View::Item) or view == nil)
			@view.deleteLater() if view?
			@view = view

			notify()
		end

		def notify()
			return unless view?

			view.primary = self.color
			view.secondary = Qt::transparent

			unless empty?
				attached.notify(geometry: self.view.geometry)
			end
		end
	end

	class Model::Chip
		include Test::Unit::Assertions
		include Debug
		attr_reader :view, :color
		attr_accessor :id

		def initialize(id: nil, color: Qt::red, view: nil)
			self.id = id
			self.color = Qt::Color.new(color)
			self.view = view
		end

		def view?()
			return view.is_a?(Board::View::Item)
		end

		def view=(view)
			assert (view.is_a?(Board::View::Item) or view == nil)
			
			@view.deleteLater() if view?
			@view = view
			
			# place chip behind tiles
			@view.lower() if view? 
			notify()
		end

		def color=(value)
			assert value.is_a?(Qt::Color)
			@color = value
		end

		def notify(geometry: nil)
			return unless view?
			view.geometry = geometry if geometry != nil
			view.primary = Qt::transparent
			view.secondary = self.color
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
		end

		def notify(geometry: nil)
			return unless view?

			case id
			when :T then view.text = "T"
			when :O then view.text = "O"
			end

			super(geometry: geometry)
		end
	end

end