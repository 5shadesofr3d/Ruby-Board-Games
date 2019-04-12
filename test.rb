require 'Qt'
require_relative 'gui/game'

Debug::on
app = Qt::Application.new ARGV

widget = Qt::Widget.new()
widget.show()

# model = Game::Model::Connect4.new()
# file = File.open('test.txt', 'r')
# model = Game::Model::Connect4.from_json(file.read)
# file.close

# model.lobby.add(Player::Online.new("Godzilla", Qt::green))
# model.lobby.notify()

s = Game::Server.new(port: 8080, model: model)
s.serve

app.exec