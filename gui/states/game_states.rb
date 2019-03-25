require 'Qt'
require "test/unit"
require_relative '../player/abstract_player'
require_relative '../debug'

class GameStateMachine < Qt::StateMachine
  include Test::Unit::Assertions
  include Debug

  attr_reader :game

  def initialize(game)
    assert game.is_a?(Game)

    super(game)
    @game = game

    assert valid?
  end

  def setup()
    assert game.is_a? Game

    lobby = GameLobbyState.new(self, game)
    start = GamePlayState.new(self, game)
    move = GamePlayerMoveState.new(self, game)
    status = GameDetermineStatusState.new(self, game)
    complete = GameEndState.new(self, game)

    lobby.addTransition(lobby, SIGNAL("done()"), start)
    start.addTransition(start, SIGNAL("done()"), move)
    move.addTransition(move, SIGNAL("done()"), status)
    status.addTransition(status, SIGNAL("win()"), complete)
    status.addTransition(status, SIGNAL("done()"), move)
    complete.addTransition(complete, SIGNAL("done()"), lobby)

    setInitialState(lobby)

    assert lobby.is_a? GameLobbyState
    assert start.is_a? GamePlayState
    assert move.is_a? GamePlayerMoveState
    assert status.is_a? GameDetermineStatusState
    assert complete.is_a? GameEndState
  end

  def valid?()
    return false unless @game.is_a?(Game)
    return true
  end

end

class GameState < Qt::State
  include Debug
  include Test::Unit::Assertions

  attr_reader :game
  signals :done

  def initialize(machine, game)
    assert machine.is_a? Qt::StateMachine
    assert game.is_a? Game
    super(machine)
    @game = game
    assert @game.is_a? Game
  end

end

class GameLobbyState < GameState

  slots 'exit_lobby()','start_game()'

  def startButton()
    assert game.is_a? Game
    return game.lobby.buttons.start
  end

  def onEntry(event)
    # show game lobby
    assert game.is_a? Game

    game.showLobby()

    # when start button is clicked, go to the next state
    connect(startButton, SIGNAL("clicked()"), self, SLOT("start_game()"))
    connect(game.lobby.buttons.exit, SIGNAL("clicked()"), self, SLOT("exit_lobby()"))
  end

  def start_game
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
  end

  def exit_lobby
    game.stop
  end

  def onExit(event)
    assert game.is_a? Game
    # disconnect the start button so it no longer works
    disconnect(startButton, SIGNAL("clicked()"))
    game.updatePlayers()

    assert game.players.is_a? Array
    assert game.players.size > 0
    assert game.players.each {|p| assert p.is_a? Player}
  end

end

class GamePlayState < GameState

  def onEntry(event)
    # show game board
    game.showBoard()
    # game time
    # game score
    done()
  end

  def onExit(event)

  end
end

class GamePlayerMoveState < GameState

  def onEntry(event)
    assert game.players.first.is_a? Player
    # get next player
    player = game.players.first
    # acknowledge moves from this player
    player.enable
    # after player completes his move, go to the next state
    connect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
  end

  def onExit(event)
    assert game.players.first.is_a? Player
    player = game.players.first
    # disconnect signal for the player that just played his move
    disconnect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
    # no longer acknowledge moves from this player
    player.disable
  end

end

class GameDetermineStatusState < GameState

  signals :win

  def onEntry(event)
    assert game.is_a? Game
    Thread.new do
      if game.winner?
        win()
      else
        # cycle to next player and get his move
        game.players.rotate!
        done()
      end
    end
  end

  def onExit(event)

  end

end

class GameEndState < GameState

  def onEntry(event)
    assert game.is_a? Game #TODO: check and assert event type
    assert game.players.first.is_a? Player
    assert game.players.each {|p| assert p.is_a? Player}
    # display winner, clear game board, score
    if (game.winner?)
      player = game.players.first
      player.wins += 1
      game.players.drop(1).each { |player| player.losses += 1 }
    else # we had a tie
      game.players.each { |player| player.ties += 1 }
    end
    game.updatePlayerInfos()
    game.board.clear()
    done()
  end

  def onExit(event)

  end

end
