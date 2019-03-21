require 'Qt'
require_relative 'gui/board/board'
require_relative 'gui/board/board_item.rb'

app = Qt::Application.new ARGV

board = Board.new(7, 8)

board.background = Qt::white
board.color = Qt::Color.new("#48dbfb")

chip_red = Connect4Chip.new(color: Qt::red, parent: board)
chip_yellow = Connect4Chip.new(color: Qt::yellow, parent: board)

chip_t = OTTOChip.new(:T, parent: board)
chip_o = OTTOChip.new(:O, parent: board)

chip_red == chip_yellow ? puts("yes") : puts("no")
chip_t == chip_o ? puts("yes") : puts("no")

board.translate(item: chip_yellow, from: board.head(3), to: board.tile(6, 3), time: 1000)
board.translate(item: chip_red, from: board.head(2), to: board.tile(6, 2), time: 1000)
board.translate(item: chip_t, from: board.head(4), to: board.tile(6, 4), time: 1000)
board.translate(item: chip_o, from: board.head(5), to: board.tile(6, 5), time: 1000)

app.exec