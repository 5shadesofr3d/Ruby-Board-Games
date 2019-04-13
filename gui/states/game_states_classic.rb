require 'Qt'
require "test/unit"
require_relative '../game'
require_relative '../player/abstract_player_classic'
require_relative '../debug'

class GameStateMachineClassic < Qt::StateMachine
  include Test::Unit::Assertions
  include Debug

  attr_reader :game

  def initialize(game)
    assert game.is_a?(Game::Game)

    super(game)
    @game = game

    assert valid?
  end

  def setup()
    assert game.is_a? Game::Game

    lobby = GameLobbyStateClassic.new(self, game)
    start = GamePlayStateClassic.new(self, game)
    move = GamePlayerMoveStateClassic.new(self, game)
    status = GameDetermineStatusStateClassic.new(self, game)
    complete = GameEndStateClassic.new(self, game)

    lobby.addTransition(lobby, SIGNAL("done()"), start)
    start.addTransition(start, SIGNAL("done()"), move)
    move.addTransition(move, SIGNAL("done()"), status)
    status.addTransition(status, SIGNAL("win()"), complete)
    status.addTransition(status, SIGNAL("done()"), move)
    complete.addTransition(complete, SIGNAL("done()"), lobby)

    setInitialState(lobby)

    assert lobby.is_a? GameLobbyStateClassic
    assert start.is_a? GamePlayStateClassic
    assert move.is_a? GamePlayerMoveStateClassic
    assert status.is_a? GameDetermineStatusStateClassic
    assert complete.is_a? GameEndStateClassic
    #assert lobby.transition.count > 0 NOTE: unfortunately it seems the qtbindings gem fails with this transitions function
    #assert start.transition.count > 0  #thse assertions would check that transitions were added
    #assert move.transition.count > 0
    #assert status.transition.count > 0
    #assert complete.transition.count > 0
  end

  def valid?()
    return false unless @game.is_a?(Game::Game)
    return true
  end

end

class GameStateClassic < Qt::State
  include Debug
  include Test::Unit::Assertions

  attr_reader :game
  signals :done

  def initialize(machine, game)
    assert machine.is_a? Qt::StateMachine
    assert game.is_a? Game::Game
    super(machine)
    @game = game
    assert @game.is_a? Game::Game
  end

end

class GameLobbyStateClassic < GameStateClassic

  slots 'exit_lobby()','start_game()'

  def startButton()
    assert game.is_a? Game::Game
    return game.lobby.buttons.start
  end

  def onEntry(event)
    # show game lobby
    assert game.is_a? Game::Game

    game.showLobby()

    # when start button is clicked, go to the next state
    connect(startButton, SIGNAL("clicked()"), self, SLOT("start_game()"))
    connect(game.lobby.buttons.exit, SIGNAL("clicked()"), self, SLOT("exit_lobby()"))
  end

  def start_game
    assert game.lobby.room.playerInfos.count > 0

    players = game.lobby.room.playerInfos
    cols = []
    duplicate = false
    for i in 0...players.count do
      pCol = players[i].color
      if cols.include? pCol
        duplicate = true
      end
      cols << pCol
    end
    if !duplicate
      done()
    end

    assert players.count > 0
  end

  def exit_lobby
    game.stop
  end

  def onExit(event)
    assert game.is_a? Game::Game
    assert game.players.size == 0
    # disconnect the start button so it no longer works
    disconnect(startButton, SIGNAL("clicked()"))
    game.updatePlayers()

    assert game.players.is_a? Array
    assert game.players.size > 0
    assert game.players.each {|p| assert p.is_a? Player::Player}
  end

end

class GamePlayStateClassic < GameStateClassic

  def onEntry(event)
    assert game.is_a? Game::Game

    # show game board
    game.showBoard()
    # game time
    # game score
    done()

    assert game.is_a? Game::Game
    assert game.board.visible
  end

  def onExit(event)

  end
end

class GamePlayerMoveStateClassic < GameStateClassic

  def onEntry(event)
    assert game.players.count > 0
    assert game.players.first.is_a? Player::Player
    # get next player
    player = game.players.first
    # acknowledge moves from this player
    connect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
    player.enable
    # after player completes his move, go to the next state

    assert player.is_a? Player::Player
  end

  def onExit(event)
    assert game.players.count > 0
    assert game.players.first.is_a? Player::Player
    player = game.players.first
    # disconnect signal for the player that just played his move
    disconnect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
    # no longer acknowledge moves from this player
    player.disable

    assert player.is_a? Player::Player
  end

end

class GameDetermineStatusStateClassic < GameStateClassic

  signals :win

  def onEntry(event)
    assert game.is_a? Game::Game
    assert game.players.count > 0

    if game.winner? or game.tie?
      win()
    else
      # cycle to next player and get his move
      game.players.rotate!
      done()
    end

    assert game.is_a? Game::Game
    assert game.players.count > 0
  end

  def onExit(event)

  end

end

class GameEndStateClassic < GameStateClassic

  def onEntry(event)
    assert game.is_a? Game::Game #TODO: check and assert event type
    assert game.players.first.is_a? Player::Player
    assert game.players.each {|p| assert p.is_a? Player::Player}
    # display winner, clear game board, score

    game.updatePlayerScores()
    game.updatePlayerInfos()
    game.board.clear()
    done()

    assert game.players.count == 0 #game is over
  end

  def onExit(event)

  end

end
