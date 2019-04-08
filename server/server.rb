require 'test/unit'
require "xmlrpc/server"

class MyHandler
  include Test::Unit::Assertions
  attr_accessor :num_players, :lobby, :num_ready,
                :current_turn

  def initialize
    @num_players = 0
    @num_ready = 0
    @lobby = []

    @current_turn = 0
    @current_move = {}
  end

  def is_valid?
    return false unless @num_players >= 0
    return false unless @num_ready >= 0
    return false unless @lobby.is_a? Array
    return true
  end

  def connect(user)
    assert is_valid?

    @num_players += 1
    @lobby.push user
    "#{user} has logged in #{@num_players} times!"
  end

  def is_ready
    assert is_valid?


    # if @num_ready == 2
    #   return true
    # end
    # return false

    return true

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
    @current_turn += 1
  end

  # Adjust mod to the number of players.
  # Returns the number for whose turn it is.
  def get_turn
    assert @current_turn.is_a? Integer

    @current_turn % 2
  end

end

class MySecondHandler

  def hello
    "Hello, second world!"
  end

end


server = XMLRPC::Server.new(1234)
server.add_handler("lobby", MyHandler.new)
# server.add_handler("game", MySecondHandler.new)
server.serve


# server_test = MyHandler.new
# server_test.connect("user2")
# puts server_test.ready