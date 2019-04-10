require 'test/unit'
require "xmlrpc/server"

require_relative 'game_server_state_machine'
require_relative 'object_converter'

class LobbyHandler
  include Test::Unit::Assertions
  attr_accessor :num_players, :lobby, :num_ready

  def initialize
    @num_players = 0
    @num_ready = 0
    @lobby = []
    @game_server = GameServerStateMachine.new (@lobby)
    @game_server.set_state(WaitingOnTurnState)
  end

  def is_valid?
    return false unless @num_players.is_a? Integer
    return false unless @num_players >= 0
    return false unless @num_ready.is_a? Integer
    return false unless @num_ready >= 0
    return false unless @lobby.is_a? Array
    return true
  end

  def connect(user)
    assert is_valid?

    user_info = {"username": user,
                 "player_num": @num_players,
                 "ack": false}

    @lobby.push user_info
    @game_server.lobby = @lobby
    @num_players += 1

    "#{user} has logged in #{@num_players} times!"
  end

  def is_ready
    assert is_valid?

    if @num_ready == 2
      return true
    end
    return false

  end

  def ready
    assert is_valid?

    @num_ready += 1
  end

  def players
    assert is_valid?

    @lobby.length
  end

  # Issue, server cannot return objects. Only primitive values.
  def current_state
    ObjectConverter.convert_to_primitive(@game_server.current_state_instance)
  end

  def server_status
    "Num players: #{@num_players} \n" +
    "Num ready: #{@num_ready} \n" +
    "Current Move: #{@game_server.current_move} \n" +
    "Current Turn: #{@game_server.current_turn} \n" +
    "Lobby: #{@lobby.to_s} \n" +
    "Game Server State #{@game_server.current_state_instance}"
  end

  def make_move(current_chip_color, current_column)
    assert @game_server.current_move.is_a? Hash
    assert @game_server.current_turn.is_a? Integer

    @game_server.next
    @game_server.current_move =  {"chip_color": current_chip_color,
                                  "column": current_column}
    return true
  end

  def get_move
    assert is_valid?

    puts server_status
    @game_server.current_move
  end

  def ack_move(username)
    assert is_valid?
    assert username.is_a? String

    @game_server.ack(username)

    return true
  end

  # Adjust mod to the number of players.
  # Returns the number for whose turn it is.
  def get_turn
    assert is_valid?
    assert @game_server.current_turn.is_a? Integer

    @game_server.current_turn % 2
  end

end


server = XMLRPC::Server.new(1235)
# server.add_handler("game", GameHandler.new)
server.add_handler("lobby", LobbyHandler.new)
server.serve

# server_test = LobbyHandler.new
# server_test.connect("user2")
# server_test.connect("user3")
# puts server_test.current_state
# server_test.make_move("Aka", 3)
# puts server_test.current_state
# server_test.ack_move("user2")
# server_test.ack_move("user3")
# puts server_test.current_state
