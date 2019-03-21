require 'Qt'
require_relative 'gui/game'
require_relative 'gui/board/board_item.rb'

app = Qt::Application.new ARGV

game = Connect4.new()
game.board.background = Qt::white
game.board.color = Qt::Color.new("#48dbfb")

game.show()

chip_red = Connect4Chip.new(color: Qt::red, parent: game.board)
chip_yellow = Connect4Chip.new(color: Qt::yellow, parent: game.board)

chip_t = OTTOChip.new(:T, parent: game.board)
chip_o = OTTOChip.new(:O, parent: game.board)

chip_red == chip_yellow ? puts("yes") : puts("no")
chip_t == chip_o ? puts("yes") : puts("no")

game.board.insert(chip_yellow, 3)
game.board.insert(chip_red, 2)
game.board.insert(chip_t, 3)
game.board.insert(chip_o, 3)

app.exec