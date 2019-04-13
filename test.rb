require 'Qt'
require_relative 'gui/game'

# Debug::on
app = Qt::Application.new ARGV

widget = Qt::Widget.new()
widget.show()

# model = Game::Model::Connect4.new()

# model.lobby.add(Player::Online.new("Godzilla", Qt::green))
# model.lobby.notify()

s = Game::Server.new()
s.serve

app.exec
