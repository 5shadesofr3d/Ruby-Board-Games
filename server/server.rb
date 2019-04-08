require 'test/unit'
require "xmlrpc/server"

class MyHandler
  include Test::Unit::Assertions
  attr_accessor :num_players, :lobby, :num_ready,
                :current_turn, :current_move

  def initialize
    @num_players = 0
    @num_ready = 0
    @lobby = []
    # each lobby element is:
    # {username: ..., player_num: ...., ack: false}

    @current_turn = 0
    @current_move = {}
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
    @num_players += 1

    "#{user} has logged in #{@num_players} times!"
  end

  def is_ready
    assert is_valid?

    if @num_ready == 2
      return true
    end
    return false

    # return true

  end

  def ready
    assert is_valid?

    @num_ready += 1
  end

  def players
    assert is_valid?

    @lobby.length
  end

  def make_move(current_chip_color, current_column)
    assert @current_move.is_a? Hash
    assert @current_turn.is_a? Integer

    @current_move = {"chip_color": current_chip_color,
                     "column": current_column}
  end

  def get_move
    @current_move
  end

  def ack_move(username)
    # If we received all acknowledgements, increment
    # the turn and reset the moves.

    if acknowledge(username)
      @current_turn += 1
      @current_move = {}

      # Reset the acknowledgements
      @lobby.each do |user_info|
        user_info["ack"] = false
      end

    end

    return true

  end

  # Adjust mod to the number of players.
  # Returns the number for whose turn it is.
  def get_turn
    assert @current_turn.is_a? Integer

    @current_turn % 2
  end

  # Processes acknowledgement for a user, returns true
  # if all acknowledgements have been received.
  def acknowledge(user)
    assert user.is_a? String

    num_acks = 0

    @lobby.each do |user_info|
      if user == user_info["username"]
        user_info["ack"] = true
      end

      if user_info["ack"]
        num_acks += 1
      end
    end

    if num_acks == @lobby.size
      return true
    end

    return false
  end

  def server_status
    "Num players: #{@num_players}
     Num ready: #{@num_ready}
     Current: #{@current_move}
     Lobby: #{@lobby.to_s}"
  end

end


server = XMLRPC::Server.new(1234)
server.add_handler("lobby", MyHandler.new)
server.serve


# server_test = MyHandler.new
# server_test.connect("user2")
# puts server_test.ready