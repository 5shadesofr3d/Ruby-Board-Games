require 'Qt'
require_relative 'gui/game'
require_relative 'gui/game/saved_game'

Debug::on
app = Qt::Application.new ARGV
#
 widget = Qt::Widget.new()
 widget.show()
#
# savedgames = SavedGames.new()
#
# model = Game::Model::Connect4.new()
#
savedgames = SavedGames.new()

model = savedgames.loadGame("GameTest")


#savedgames.saveGame("GameTest", 3, model)

 # model.lobby.add(Player::Online.new("Godzilla", Qt::green))
 model.lobby.notify()

 s = Game::Server.new(port: 8080, model: model)
 s.serve
#
 app.exec