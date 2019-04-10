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

    super(game) if game.is_a?(Qt::Object)
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
    #assert lobby.transition.count > 0 NOTE: unfortunately it seems the qtbindings gem fails with this transitions function
    #assert start.transition.count > 0  #thse assertions would check that transitions were added
    #assert move.transition.count > 0
    #assert status.transition.count > 0
    #assert complete.transition.count > 0
  end

  def valid?
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

  def startButton
    assert game.is_a? Game
    return game.lobby.view.buttons.start
  end

  def exitButton
    assert game.is_a? Game
    return game.lobby.view.buttons.exit
  end

  def onEntry(event)
    # show game lobby
    assert game.is_a? Game

    game.showLobby

    # when start button is clicked, go to the next state
    connect(startButton, SIGNAL("clicked()"), self, SIGNAL("done()"))
    connect(exitButton, SIGNAL("clicked()"), self, SLOT("exit_lobby()"))
  end

  def onExit(event)
    assert game.is_a? Game
    # assert game.players.size == 0 TODO: Assertion bug?
    # disconnect the start button so it no longer works
    disconnect(startButton, SIGNAL("clicked()"))
    disconnect(exitButton, SIGNAL("clicked()"))
    game.updatePlayers()

    assert game.players.is_a? Array
    assert game.players.size > 0
    assert game.players.each {|p| assert p.is_a? Player}
  end

end

class GamePlayState < GameState

  def onEntry(event)
    assert game.is_a? Game

    # show game board
    game.showBoard()
    # game time
    # game score
    done()

    assert game.is_a? Game
    assert game.board.visible
  end

  def onExit(event)

  end
end

class GamePlayerMoveState < GameState

  def onEntry(event)
    assert game.players.count > 0
    assert game.players.first.is_a? Player
    # get next player
    player = game.players.first
    # acknowledge moves from this player
    connect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
    player.enable
    # after player completes his move, go to the next state

    assert player.is_a? Player
  end

  def onExit(event)
    assert game.players.count > 0
    assert game.players.first.is_a? Player
    player = game.players.first
    # disconnect signal for the player that just played his move
    disconnect(player, SIGNAL("finished()"), self, SIGNAL("done()"))
    # no longer acknowledge moves from this player
    player.disable

    assert player.is_a? Player
  end

end

class GameDetermineStatusState < GameState

  signals :win

  def onEntry(event)
    assert game.is_a? Game
    assert game.players.count > 0

    if game.winner? or game.tie?
      win()
    else
      # cycle to next player and get his move
      game.players.rotate!
      done()
    end

    assert game.is_a? Game
    assert game.players.count > 0
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

    game.updatePlayerScores()
    game.updatePlayerInfos()
    game.board.clear()
    done()

    assert game.players.count == 0 #game is over
  end

  def onExit(event)

  end

end
