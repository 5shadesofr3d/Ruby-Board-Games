# Group members
# Vishal Patel
# Rizwan Qureshi
# Curtis Goud
# Jose Ramirez
# Jori Romans
require 'Qt'
require 'json'
require_relative 'gui/game'
require_relative 'gui/player'
require_relative 'gui/board'
require_relative 'gui/debug'
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
app = GameApplication.new()

# app = Qt::Application.new []

# player = Game::Model::Connect4.new()
# data = JSON.dump(player)
# puts data
# p2 = JSON.load(data)

# username = ARGV.first
# client = Game::Client.new(username: username)
# model = Game::Model::Connect4.new()
# model.addView Game::View.new(model.rows, model.columns)
# model.start()

# model.lobby.add(Player::Online.new("Godzilla", Qt::green))
# model.lobby.notify()

# model = Board::Model.new(7, 8)
# view = Board::View.new(model.rowSize, model.columnSize)
# controller = Board::Controller.new()
# view.show()

# view.update(model)

# chip_model = Board::Model::Chip.new()
# chip_view = Board::View::Chip.new(parent: view)

# controller.drop(
# 	chip_model: chip_model, chip_view: chip_view,
# 	board_model: model, board_view: view,
# 	column: 0)

# app.exec