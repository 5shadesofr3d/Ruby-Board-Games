require 'test/unit'

require_relative 'abstract_player'
require_relative 'local_player'

class MultiplayerOnlinePlayer < Player

  def drop
    assert game.is_a? Game
    assert current_column.is_a? Integer
    assert current_column >= 0
    assert current_chip.is_a? BoardChip

    game.board.drop(current_chip, 1)

    # Update server with current move.
    client = Client.instance.conn
    client.call2("lobby.make_move", current_chip, 1)

    @current_chip = nil
    assert @current_chip == nil
  end


end

class MultiplayerLocalPlayer < LocalPlayer

  def drop
    assert game.is_a? Game
    assert current_column.is_a? Integer
    assert current_column >= 0
    assert current_chip.is_a? BoardChip

    game.board.drop(current_chip, current_column)

    # Update server with current move.
    client = Client.instance.conn
    client.call2("lobby.make_move", current_chip.color, current_column)

    @current_chip = nil
    assert @current_chip == nil
  end


end