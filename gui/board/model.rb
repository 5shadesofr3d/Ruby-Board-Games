require 'Qt'
require 'test/unit'
require 'chroma'
require_relative 'iterator'
require_relative 'view'
require_relative '../debug'

class BoardModel
	include Test::Unit::Assertions
	include BoardIterator

	attr_reader :parent

	def initialize(rows, cols, parent: nil)
		assert rows.is_a? Integer
		assert cols.is_a? Integer
		assert rows > 0
		assert cols > 0

		@parent = parent

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

	def head(col)
		assert col.is_a?(Integer) and columns.include?(col)
		assert valid?

		return @head[col]
	end

	def tile(row, col)
		assert row.is_a?(Integer) and rows.include?(row)
		assert col.is_a?(Integer) and columns.include?(col)

		return @tile[row][col]
	end

	def chip(row, col)
		return tile(row, col).attached
	end

	def color=(c)
		each(:tile) { |tile| tile.primary = c }
	end

	def boardSize()
		return @rows * @cols
	end

private
  # Takes values of format: rgb(X, X, X) and
  # outputs a Qt color
  def rgbString_to_QtColor(input)
    Qt::Color.fromRgb(input.paint.rgb.r,
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
				item = BoardTile.new(color: tile_color, parent: parent)
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
			item = BoardHead.new(parent: parent)
			@head << item
		end

		@head.size == @cols
	end

end
