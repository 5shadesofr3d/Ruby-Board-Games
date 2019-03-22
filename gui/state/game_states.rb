require 'Qt'
require "test/unit"
require 'state_pattern'
require_relative '../player/player'
require_relative '../debug'

class GameInitial < StatePattern::State
  include Debug

  def enter

  end

  def next()
    transition_to(GamePlay)
  end

  def execute

  end

  def exit

  end

end

class GameStateMachine < Qt::Object
  include Test::Unit::Assertions  
  include StatePattern
  include Debug
  
  set_initial_state(GameInitial)

  slots :next

  attr_reader :game

  def initialize(game)
    assert game.is_a?(Game)

    super(game)
    @game = game

    assert valid?
  end

  def valid?()
    return false unless @game.is_a?(Game)
    return true
  end

end

class GameLobby < StatePattern::State
  include Debug

  def start_button()
    return stateful.game.lobby.buttons.start
  end

  def next()
    transition_to(GamePlay)
  end

  def enter()
    # show game lobby
    stateful.game.showLobby()

    # when start button is clicked, go to the next state
    stateful.connect(start_button, SIGNAL("clicked()"), stateful, SLOT("next()"))
  end

  def exit()
    # disconnect the start button so it no longer works
    stateful.disconnect(start_button, SIGNAL("clicked()"))
    stateful.game.updatePlayers()
  end

end

class GamePlay < StatePattern::State
  include Debug

  def enter()
    # show game board
    stateful.game.showBoard()
    # game time
    # game score
    transition_to(GamePlayerMove)
  end

  def exit()

  end
end

class GamePlayerMove < StatePattern::State
  include Debug

  def enter()
    # get next player
    # connect signal for next player move
  end

  def next()
    transition_to(GameDetermineStatus)
  end

  def exit()
    # disconnect signal for the player that just played his move
  end
end

class GameDetermineStatus < StatePattern::State
  include Debug

  def enter()
    # check for a winner

    # if winner
    transition_to(GameEnd)
  end

  def next()
    transition_to(GamePlayerMove)
  end

  def exit

  end
end

class GameEnd < StatePattern::State
  include Debug

  def enter()
    # display winner, clear game board, score
  end

  def next()
    # transition_to(GamePlay)
  end

  def exit()

  end
end

class GameClear < StatePattern::State
  def clear_board
    #pre
    assert valid?
    @board.is_a? Board

    #clear the board

    #post
    @board.is_a? Board
    assert valid?
  end
end

class PlayerTurnState < StatePattern::State
  include Test::Unit::Assertions

  def initialize(game_type,piece_type,player)
    #pre
    assert game_type.is_a? Game
    assert piece_type.is_a? BoardItem
    assert player.is_a? Player

    @player = player
    @game_type = game_type
    @piece_type = piece_type

    #post
    assert @game_type.is_a? Game
    assert @piece_type.is_a? BoardItem
    assert @player.is_a? Player
  end

  def valid?
    #class invariant
    @game_type.is_a? Game
    @piece_type.is_a? BoardItem
    @player.is_a? Player
  end

  def begin_turn
    #pre
    assert valid?
    @player.is_a? Player

    #player do things

    #post
    @player.is_a? Player
    assert valid?
  end

  def perform_move(colNumber)
    #pre
    assert valid?
    assert colNumber.is_a? Numeric
    assert @board.is_a? Board
    assert colNumber > 0
    assert colNumber < @board.columns
    assert @player.is_a? Player
    #NOTE: What else makes a move valid? Add if you have any

    #perform move

    #post
    assert colNumber.is_a? Numeric
    assert colNumber > 0
    assert @player.is_a? Player
    assert valid?
  end
end

class GameCompleteState < StatePattern::State
  include Test::Unit::Assertions

  def initialize(game_type,board,players)
    #pre
    assert game_type.is_a? Game
    assert board.is_a? Board
    assert players.is_a? Array
    players.each {|a| assert a.is_a? Player}

    @game_type = game_type
    @board = board
    @players = players

    #post
    assert @game_type.is_a? Game
    assert @board.is_a? Board
    assert @players.is_a? Array
    @players.each {|a| assert a.is_a? Player}
  end

  def valid?
    #class invariant
    assert @game_type.is_a? Game
    assert @board.is_a? Board
    assert @players.is_a? Array
    @players.each {|a| assert a.is_a? Player}
  end

  def modify_score(player, score)
    #pre
    assert valid?
    assert player.is_a? Player
    assert score.is_a? Numeric

    #do stuff with score & player

    #post
    assert player.score >= score
    assert player.is_a? Player
    assert score.is_a? Numeric
    assert valid?
  end

  def end_game(winner)
    #pre
    assert valid?
    assert board.is_a? Board
    assert winner.is_a? Player

    # end game, clear board, show winner

    #post
    assert board.is_a? Board
    assert winner.is_a? Winner
    assert valid?
  end

  def exit_state
    #pre
    assert valid?

    # end state, transition out

  end

  def display_score(player)
    #pre
    assert valid?
    assert player.is_a? Player

    #show winner/score

    #post
    assert player.is_a? Player
    assert valid?
  end

end
