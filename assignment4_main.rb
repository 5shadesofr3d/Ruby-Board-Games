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

client = Game::Client.new()
# model = Game::Model::Connect4.new()
# model.addView Game::View.new(model.rows, model.columns)
# model.start()

# model.lobby.add(Player::Online.new("Godzilla", Qt::green))
# model.lobby.notify()

app.exec