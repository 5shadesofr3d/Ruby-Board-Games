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

		def initialize(rows, cols, tile: [], head: [])
			assert rows.is_a? Integer
			assert cols.is_a? Integer
			assert rows > 0
			assert cols > 0

			@rows = rows
			@cols = cols
			@tile = tile
			@head = head

			setBoardSize(rows, cols) unless head.size > 0

			assert valid?
		end

		def to_json(options={})
			return {
				'row' => @rows,
				'col' => @cols,
				'tile' => @tile,
				'head' => @head
			}.to_json
		end

		def self.from_json(string)
			data = JSON.load string
			t = data['tile'].map { |r| r.map { |c| Board::Model::Tile::from_h(c) } }
			h = data['head'].map { |t| i = Board::Model::Tile::from_h(t); i.color = Qt::transparent; i }
			return new data['row'], data['col'], tile: t, head: h
		end

		def _dump(level)
			[@rows, @cols, Marshal.dump(@tile), Marshal.dump(@head)].join("<BM>")
		end

		def self._load(args)
			r, c, t, h = *args.split("<BM>")
			return new(r.to_i, c.to_i, tile: Marshal.load(t), head: Marshal.load(h))
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
			assert (view.is_a?(Board::View) or view.is_a?(Board::View::Proxy))
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
					item = Board::Model::Tile.new(color: tile_color, row: r, column: c)
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
				item = Board::Model::Tile.new(color: Qt::transparent, column: col)
				@head << item
			end

			@head.size == @cols
		end
	end

	class Model::Tile
		include Test::Unit::Assertions
		attr_reader :views, :attached, :row, :column
		attr_reader :color

		def initialize(color: Qt::transparent, row: 0, column: 0, view: nil)
			@row = row
			@column = column
			@color = Qt::Color.new(color)
			@views = []
		end

		def to_json(options={})
			return {
				'attached' => @attached.to_json,
				'color' => @color.name,
				'row' => @row,
				'column' => @column
			}.to_json
		end

		def self.from_json(string)
			data = JSON.load string
			return self.from_h(data)
		end

		def self.from_h(data)
			tile = new color: data['color'], row: data['row'], column: data['column']
			tile.attach(Board::Model::Chip::from_json(data['attached'])) unless data['attached'].nil?
			return tile
		end

		def color=(value)
			@color = Qt::Color.new(value)
		end

		def attach(chip)
			assert (chip.is_a?(Board::Model::Chip) or chip.nil?)
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
			assert (view.is_a?(Board::View::Item) or view.is_a?(Board::View::Tile::Proxy))
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
		attr_reader :views, :color, :text
		attr_accessor :id

		def initialize(id: nil, color: Qt::red, view: nil)
			@text = ""
			self.id = id
			self.color = Qt::Color.new(color)
			@views = []
		end

		def to_json(options={})
			return {
				'id' => @id,
				'color' => @color.name,
			}.to_json
		end

		def self.from_json(string)
			data = JSON.load string
			return data if data.nil?
			return new id: data['id'], color: data['color']
		end

		def addView(view)
			assert (view.is_a?(Board::View::Item))
			@views << view
			view.lower()
			notify()
		end

		def color=(value)
			@color = Qt::Color.new(value)
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