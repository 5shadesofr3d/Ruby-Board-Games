require 'Qt'
require_relative 'gui/game'
require_relative 'gui/player/lobby'
require_relative 'gui/board'
require_relative 'gui/debug'
require_relative 'application'

Debug::on

app = GameApplication.new

# app = Qt::Application.new ARGV

# board = Board.new(7, 8)
# board.background = Qt::white
# board.color = Qt::Color.new("#48dbfb")

# lobby = PlayerLobby.new()
# lobby.show()

# lobby.addPlayer
# lobby.addPlayer

# game = Connect4.new()
# game.board.background = Qt::white
# game.board.color = Qt::Color.new("#48dbfb")
# game.show()
# game.start()

# chip_red = Connect4Chip.new(color: Qt::red, parent: board)
# chip_yellow = Connect4Chip.new(color: Qt::yellow, parent: board)

# chip_t = OTTOChip.new(:T, parent: board)
# chip_o = OTTOChip.new(:O, parent: board)

# chip_red == chip_yellow ? puts("yes") : puts("no")
# chip_t == chip_o ? puts("yes") : puts("no")

# model = board.model
# board.translate(item: chip_yellow, from: model.head(0), to: model.head(4), time: 1000)

# board.insert(chip_yellow, 3)
# board.drop(chip_red, 2)
# board.drop(chip_t, 3)
# board.drop(chip_o, 3)

# app.exec