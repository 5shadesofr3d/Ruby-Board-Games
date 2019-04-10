require 'Qt'
require 'test/unit'
require_relative 'board/model'
require_relative 'board/view'
require_relative 'board/controller'
require_relative 'debug'

module Board
	class Widget < Qt::Widget
		include Test::Unit::Assertions
		include Debug

		attr_reader :model, :controller

		def initialize(rows, cols, width: 800, height: 600, parent: nil)
			assert rows.is_a? Integer
			assert cols.is_a? Integer
			assert rows > 0
			assert cols > 0
			parent != nil ? super(parent) : super()

			@model = Board::Model.new(rows, cols)
			@controller = Board::Controller.new(parent: self)

			setupUI()

			assert @model.is_a? Board::Model
			assert valid?
		end

		def valid?
			return false unless @layout.is_a?(Qt::GridLayout) or @layout == nil
			return false unless @model.is_a?(Board::Model)
			return false unless @controller.is_a?(Board::Controller)

			return true
		end

		def setupUI()
			setupViews()
			setupLayout()
			setupWindow(width, height)
			setupBackground()
		end

		def setupViews()
			@model.each(:head) { |head| head.view = Board::View.new(parent: self) }
			@model.each(:tile) { |tile| tile.view = Board::View.new(parent: self) }
		end

		def setupLayout()
			@layout = Qt::GridLayout.new(self)
			@layout.setSpacing(0)
			setLayout(@layout)

			@model.each_with_index(:head) { |head, row, col| @layout.addWidget(head.view, row, col) if head.view != nil }
			@model.each_with_index(:tile) { |tile, row, col| @layout.addWidget(tile.view, row + 1, col) if tile.view != nil }
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

		# TODO: Might not be worth fixing. Set the background of the window.
		def setupBackground
			#theme = Settings.instance.theme
			#setStyleSheet("background-color: #{theme.color[:board_background]};")
		end

		def clear()
			@model.each(:tile) {|tile| tile.detach }
			@model.update()
		end

		def color=(c)
			@model.color = c
		end

		def drop(chip, col, time: 750)
			@controller.drop(chip, col, @model, time: time)
		end

		def translate(item: nil, from: nil, to: nil, time: 0)
			@controller.translate(item: item, from: from, to: to, time: time)
		end
	end
end
