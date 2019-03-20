require 'Qt'
require_relative 'gui/board/board'
require_relative 'gui/board/board_item.rb'

app = Qt::Application.new ARGV

board = Board.new(7, 8)

board.background = Qt::white
board.color = Qt::Color.new("#48dbfb")

chip = BoardChip.new(color: Qt::red, parent: board)

board.translate(item: chip, from: board.head(3), to: board.tile(6, 3), time: 1000)

app.exec