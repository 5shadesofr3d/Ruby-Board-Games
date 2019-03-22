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

board.insert(chip_yellow, 3)
board.insert(chip_red, 3)
board.insert(chip_t, 3)
board.insert(chip_o, 3)

app.exec