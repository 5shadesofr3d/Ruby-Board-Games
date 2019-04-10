require 'test/unit'

require_relative 'abstract_player'
require_relative 'local_player'
require_relative '../../server/game_server_state_machine'
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

    while client.conn.call2("lobby.current_state")[1] ==
                                          "WaitingOnTurnState"
      sleep 1
    end

    turn = client.conn.call2("lobby.get_move")[1]

    @current_column = turn["column"]
    client.conn.call2("lobby.ack_move",
                       Client.instance.username)

    # Loop as long as we don't have all acknowledgements.
    while client.conn.call2("lobby.current_state")[1] ==
                                        "WaitingOnAllAcksState"
      sleep 1
    end

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

    # Wait until its our turn to make a move.
    # while not(client.conn.call("lobby.current_turn") ==
    #     client.player_number)
    #   puts "stuck here1"
    #   sleep(1)
    # end

    # This can be done via state machine
    # client.conn.call("lobby.set_all_ack", false)

    super
  end

  def drop
    assert game.is_a? Game
    assert current_column.is_a? Integer
    assert current_column >= 0
    assert current_chip.is_a? BoardChip

    game.board.drop(current_chip, current_column)

    puts "Column #{@current_column} #{@current_column.class.name} #{@current_chip.color} #{@current_chip.color.class.name}"

    # Update server with current move.
    client = Client.instance.conn
    client.call2("lobby.make_move",
                 @current_chip.color,
                 @current_column.to_i)

    client.call2("lobby.ack_move",
                 Client.instance.username)

    # Loop as long as we don't have all acknowledgements.
    while client.call2("lobby.current_state")[1] ==
                                          "WaitingOnAllAcksState"
      sleep 1
      puts client.call("lobby.server_status")
    end

    @current_chip = nil
    assert @current_chip == nil
  end


end