# Group members
# Vishal Patel
# Rizwan Qureshi
# Curtis Goud
# Jose Ramirez
# Jori Romans
require 'Qt'
require_relative 'gui/game'
require_relative 'gui/board'
require_relative 'gui/debug'
require_relative 'server/network'
require_relative 'application'

# Bugs:
# - Need to fix those animation bugs with the AI player,
# the bugs also exist for the online player.
#
# - The board fails to load before the user takes a turn.


# To run assignment4_main.rb, ensure you have the following
# dependancies:
#
# gem install state_pattern
# gem install qtbindings
# gem install chroma


Debug::on # may cause animation lag due to excessive printing to terminal
# app = GameApplication.new

app = Qt::Application.new ARGV

# board = Board.new(7, 8)
# board.background = Qt::white
# board.color = Qt::Color.new("#48dbfb").name

# lobby = PlayerLobby.new()
# lobby.show()

# lobby.addPlayer
# lobby.addPlayer

model = Game::Model::OTTO.new()
model.view = Game::View.new(model.rows, model.columns)
model.start()

model.lobby.add(Player::Online.new("Godzilla", Qt::green))
model.lobby.notify()

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

app.exec