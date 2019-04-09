require 'test/unit'

require_relative 'abstract_player'
require_relative 'local_player'

# Todo: Need error handling for bad opponent moves.
class MultiplayerOnlinePlayer < Player

  def enable
    super
    self.play
  end

  def play
    assert game.is_a? Game

    @current_column = 1

    client = Client.instance

    # TODO: Remove, replace with alternate waiting method
    # to allow other clients to catch up.
    sleep(2)

    while client.conn.call2("game.stateful")[1].empty?
      sleep 1
    end

    turn = client.conn.call2("lobby.get_move")[1]

    @current_column = turn["column"]
    client.conn.call2("lobby.ack_move",
                       Client.instance.username)

    puts client.conn.call("lobby.server_status")

    # Loop as long as we don't have all acknowledgements.
    while not(client.conn.call("lobby.all_ack"))
      sleep 1
    end

    client.conn.call("lobby.update_moving_on")

    drop
    finished

    assert @current_column.is_a? Integer
  end

  def drop
    assert game.is_a? Game
    assert current_column.is_a? Integer
    assert current_column >= 0
    assert current_chip.is_a? BoardChip

    game.board.drop(@current_chip, @current_column)

    # Update server with current move.
    client = Client.instance.conn
    client.call2("lobby.make_move",
                 @current_chip.color,
                 @current_column)

    @current_chip = nil
    assert @current_chip == nil
  end


end

class MultiplayerLocalPlayer < LocalPlayer

  def enable

    client = Client.instance

    puts "Reached: MultiplayerLocalPlayer"

    # Wait until its our turn to make a move.
    while not(client.conn.call("lobby.current_turn") ==
        client.player_number)
      puts "stuck here1"
      sleep(1)
    end

    # By now the current move should have been reset.
    # Wait until all online players have passed the
    # waiting state
    while client.conn.call("lobby.moving_on") < 1
      puts "stuck here2"
      sleep(1)
    end

    client.conn.call("lobby.reset_moving_on")

    # This can be done via state machine
    client.conn.call("lobby.set_all_ack", false)

    super
  end

  def drop
    assert game.is_a? Game
    assert current_column.is_a? Integer
    assert current_column >= 0
    assert current_chip.is_a? BoardChip

    game.board.drop(current_chip, current_column)

    # Update server with current move.
    client = Client.instance.conn
    client.call2("lobby.make_move",
                 @current_chip.color,
                 @current_column)

    client.call2("lobby.ack_move",
                 Client.instance.username)

    puts client.call("lobby.server_status")

    @current_chip = nil
    assert @current_chip == nil
  end


end