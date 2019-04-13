require 'Qt'
require "test/unit"
require_relative '../player'
require_relative '../debug'
require_relative '../game'

class GameStateMachine < Qt::StateMachine
  include Test::Unit::Assertions
  include Debug

  attr_reader :client
  attr_accessor :current_state

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

  attr_reader :client, :machine
  signals :done

  def initialize(machine, client)
    assert machine.is_a? Qt::StateMachine
    assert client.is_a? Game::Client
    super(machine)
    @client = client
    @machine = machine
    assert @client.is_a? Game::Client
  end

  def clazz()
    return self.class.name
  end

end

class GameLobbyState < GameState

  def startButton()
    #loadedGameText = client.view.lobby.buttons.loadedGame
    #savedGame = SavedGames.new()
    #loadedGameObject = savedGame.loadGame(loadedGameText)

    return client.view.lobby.buttons.start
  end

  def exitButton()
    return client.view.lobby.buttons.exit
  end

  def onEntry(event)
    assert client.is_a? Game::Client

    machine.current_state = self
    client.push if client.user.host
    client.view.showLobby

    connect(startButton, SIGNAL("clicked()"), self, SIGNAL("done()"))
    connect(exitButton, SIGNAL("clicked()"), client, SLOT("exit()"))

    client.timer.start
  end

  def onExit(event)
    assert client.is_a? Game::Client
    # assert client.players.size == 0 TODO: Assertion bug?
    client.timer.stop
    model = client.current_model

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

    machine.current_state = self
    if client.user.host
      client.push
      client.model.pregameSetup()
    end

    done()

    assert client.is_a? Game::Client
  end

  def onExit(event)
    client.update
    client.update
  end
end

class GamePlayerMoveState < GameState

  def onEntry(event)
    machine.current_state = self
    model = client.current_model
    if client.user.name == model.players.first.name
      client.push
      connect(client.user, SIGNAL("finished()"), self, SIGNAL("done()"))
      client.user.enable(model)
    else
      client.timer.start
    end

    client.update
  end

  def onExit(event)
    model = client.current_model
    if client.user.name == model.players.first.name
      client.user.disable
      disconnect(client.user, SIGNAL("finished()"), self, SIGNAL("done()"))
      client.push(model: client.user.model)
    else
      client.timer.stop
    end
    client.update if client.user.name == model.players.first.name
  end

end

class GameDetermineStatusState < GameState
  signals :win

  def onEntry(event)
    machine.current_state = self

    model = client.current_model
    if client.user.name == model.players.first.name
      client.push
    end

    assert client.is_a? Game::Client
    assert model.players.count > 0

    if model.winner? or model.tie?
      win()
    else
      client.lobby.rotate! if client.user.name == model.players.first.name
      done()
    end

    assert client.is_a? Game::Client
    assert model.players.count > 0
  end

  def onExit(event)
    client.update
    client.update
  end

end

class GameEndState < GameState

  def onEntry(event)
    machine.current_state = self

    model = client.current_model
    if client.user.name == model.players.first.name
      model.updatePlayerScores()
      Board::Controller::clear(model.board)
      client.push(model: model)
    end

    assert client.is_a? Game::Client #TODO: check and assert event type
    assert model.players.first.is_a? Player::Abstract
    assert model.players.each { |p| assert p.is_a? Player::Abstract }

    done()
  end

  def onExit(event)
      client.update
  end

end
