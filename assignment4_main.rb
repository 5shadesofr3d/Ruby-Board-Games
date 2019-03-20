require 'Qt'
require_relative 'gui/board/board'

app = Qt::Application.new ARGV

board = Board.new(7, 8)
board.show()

board.background = Qt::white
board.color = Qt::Color.new("#48dbfb")

app.exec