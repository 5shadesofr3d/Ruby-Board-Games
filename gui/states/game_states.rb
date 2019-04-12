require 'Qt'
require "test/unit"
require_relative '../player'
require_relative '../debug'
require_relative '../game'

class GameStateMachine < Qt::StateMachine
  include Test::Unit::Assertions
  include Debug

  attr_reader :client

  def initialize(client)
    assert client.is_a?(Game::Client)

    client.is_a?(Qt::Object) ? super(client) : super()
    @client = client

    assert valid?
  end

  def setup()
    assert client.is_a? Game::Client

    lobby = GameLobbyState.new(self, client)
    start = GamePlayState.new(self, client)
    move = GamePlayerMoveState.new(self, client)
    status = GameDetermineStatusState.new(self, client)
    complete = GameEndState.new(self, client)

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
    return false unless @client.is_a?(Game::Client)
    return true
  end

end

class GameState < Qt::State
  include Debug
  include Test::Unit::Assertions

  attr_reader :client
  signals :done

  def initialize(machine, client)
    assert machine.is_a? Qt::StateMachine
    assert client.is_a? Game::Client
    super(machine)
    @client = client
    assert @client.is_a? Game::Client
  end

end

class GameLobbyState < GameState
  def startButton()
    return client.view.lobby.buttons.start
  end

  def exitButton()
    return client.view.lobby.buttons.exit
  end

  def onEntry(event)
    # show game lobby
    assert client.is_a? Game::Client

    client.view.showLobby

    # when start button is clicked, go to the next state
    connect(startButton, SIGNAL("clicked()"), self, SIGNAL("done()"))
    connect(exitButton, SIGNAL("clicked()"), self, SLOT("exit_lobby()"))
  end

  def onExit(event)
    assert client.is_a? Game::Client
    model = client.query_model
    # assert client.players.size == 0 TODO: Assertion bug?
    # disconnect the start button so it no longer works
    disconnect(startButton, SIGNAL("clicked()"), self, SIGNAL("done()"))
    disconnect(exitButton, SIGNAL("clicked()"), self, SLOT("exit_lobby()"))

    assert model.players.is_a? Array
    assert model.players.size > 0
    assert model.players.each {|p| assert p.is_a? Player::Abstract}
  end

end

class GamePlayState < GameState

  def onEntry(event)
    assert client.is_a? Game::Client

    client.view.showBoard()
    client.model.pregameSetup()
    done()

    assert client.is_a? Game::Client
  end

  def onExit(event)
    client.update()
  end
end

class GamePlayerMoveState < GameState

  def onEntry(event)
    model = client.query_model
    if client.user.name == model.players.first.name
      connect(client.user, SIGNAL("finished()"), self, SIGNAL("done()"))
      client.user.enable(model)
    end
  end

  def onExit(event)
    model = client.query_model
    if client.user.name == model.players.first.name
      client.user.disable
      disconnect(client.user, SIGNAL("finished()"), self, SIGNAL("done()"))
      client.deliver
    end
  end

end

class GameDetermineStatusState < GameState

  signals :win

  def onEntry(event)
    model = client.query_model
    assert client.is_a? Game::Client
    assert model.players.count > 0

    if model.winner? or model.tie?
      win()
    else
      model.players.rotate!
      done()
    end

    assert client.is_a? Game::Client
    assert model.players.count > 0
  end

  def onExit(event)

  end

end

class GameEndState < GameState

  def onEntry(event)
    model = client.query_model
    assert client.is_a? Game::Client #TODO: check and assert event type
    assert model.players.first.is_a? Player::Abstract
    assert model.players.each { |p| assert p.is_a? Player::Abstract }

    # clear game board (DONE BY SERVER?)

    done()
  end

  def onExit(event)

  end

end
