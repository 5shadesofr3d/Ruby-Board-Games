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
  end

  def valid?()
    return false unless @game.is_a?(Game)
    return true
  end

end

class GameState < Qt::State
  include Debug

  attr_reader :game
  signals :done

  def initialize(machine, game)
    super(machine)
    @game = game
  end

end

class GameLobbyState < GameState

  def startButton()
    return game.lobby.buttons.start
  end

  def onEntry(event)
    # show game lobby
    game.showLobby()

    # when start button is clicked, go to the next state
    connect(startButton, SIGNAL("clicked()"), self, SIGNAL("done()"))
  end

  def onExit(event)
    # disconnect the start button so it no longer works
    disconnect(startButton, SIGNAL("clicked()"))
    game.updatePlayers()
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
    # get next player
    player = game.players.first
    # acknowledge moves from this player
    player.enable
    # after player completes his move, go to the next state
    connect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
  end

  def onExit(event)
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