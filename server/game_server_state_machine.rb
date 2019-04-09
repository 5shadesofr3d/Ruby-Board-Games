require "test/unit"
require 'state_pattern'

class WaitingOnAllPassState < StatePattern::State
  include Test::Unit::Assertions

  def next
    transition_to(WaitingOnTurnState)
  end
end

class WaitingOnAllAcksState < StatePattern::State
  include Test::Unit::Assertions

  def next
    transition_to(WaitingOnAllPassState)
  end

end

class WaitingOnTurnState < StatePattern::State
  include Test::Unit::Assertions

  def next
    transition_to(WaitingOnAllAcksState)
  end

end

class GameServerStateMachine
  include StatePattern
  include Test::Unit::Assertions
  set_initial_state(WaitingOnTurnState)
  attr_accessor :current_turn, :current_move,
                :all_ack, :moving_on, :lobby

  def initialize(lobby)
    assert lobby.is_a? Array

    @all_ack = false
    @moving_on = 1
    # each lobby element is:
    # {username: ..., player_num: ...., ack: false}

    @lobby = lobby
    @current_turn = 0
    @current_move = {}
  end

  def ack(username)
    assert username.is_a? String

    # If we received all acknowledgements, increment
    # the turn and reset the moves.

    if acknowledge(username)
      @all_ack = true
      @current_turn += 1
      @current_move = {}

      self.next

      # Reset the acknowledgements
      @lobby.each do |user_info|
        user_info["ack"] = false
      end

    end

  end

  # Processes acknowledgement for a user, returns true
  # if all acknowledgements have been received.
  def acknowledge(user)
    assert user.is_a? String

    num_acks = 0

    @lobby.each do |user_info|
      if user == user_info[:username]
        user_info[:ack] = true
      end

      if user_info[:ack]
        num_acks += 1
      end

    end

    if num_acks == @lobby.size
      return true
    end

    # puts "acking: " + user + " " + num_acks.to_s + " " + @lobby.size.to_s
    return false
  end

end

game = GameServerStateMachine.new([{"username": "user1",
                                         "player_num": 0,
                                         "ack": false},
                                        {"username": "user2",
                                         "player_num": 1,
                                         "ack": false}])
puts game.current_state_instance
game.current_move = {"chip_color": "Red",
                     "column": 3}
game.next
puts game.current_state_instance
game.ack("user1")
puts game.current_state_instance
game.ack("user2")
puts game.current_state_instance