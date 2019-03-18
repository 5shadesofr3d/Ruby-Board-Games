require "test/unit"
require 'state_pattern'
require 'player_abstract'
require_relative 'application_states.rb'

class GameState < StatePattern::State
  include Test::Unit::Assertions

  def initialize(playerCount,boardDim)
    #pre
    assert playerCount.is_a? Numeric
    assert boardDim.is_a? Numeric
    assert playerCount > 0
    assert boardDim > 0

    @players = []
    @board = new Board(boardDim) #TODO: Possible dependency injection here?
    @game_type = Game(playerCount) #TODO: Make this Connect4/TOOT/OTTO

    #post
    assert playerCount.is_a? Numeric
    assert boardDim.is_a? Numeric
    assert playerCount > 0
    assert boardDim > 0
  end

  def valid?
    #class invariant
    @players.is_a? Array
    @players.each {|a| a.is_a? Player}
    @board.is_a? Board
    @game_type.is_a? Game
  end

  def start_game
    #pre
    assert valid?
    assert @board.is_a? Board

    #setup board

    #post
    assert @board.is_a? Board
    assert valid?
  end

  #Main game loop
  def play_game
    #pre
    assert valid?
    assert @players.is_a? Array
    @players.each {|a| a.is_a? Player}
    @board.is_a? Board

    #loop player turns and perform actions on the board

    #post
    @board.is_a? Board
    assert @players.is_a? Array
    @players.each {|a| a.is_a? Player}
    assert valid?
  end

  #do a players turn
  def player_turn
    #pre
    assert valid?
    assert @players.is_a? Array
    @players.each {|a| a.is_a? Player}

    #perform a turn

    #post
    assert @players.is_a? Array
    @players.each {|a| a.is_a? Player}
    assert valid?
  end

  def end_game
    #pre
    assert valid?
    @board.is_a? Board
    @game_type.is_a? Game

    #cleanup and end the game, switch states.

    #post
    @game_type.is_a? Game
    @board.is_a? Board
    assert valid?
  end

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
