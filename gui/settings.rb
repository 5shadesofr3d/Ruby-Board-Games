require 'singleton'
require "test/unit"

class Settings
  include Test::Unit::Assertions
  include Singleton

  attr_accessor :game_type, :game_mode, :number_of_players
  attr_accessor :theme
  attr_accessor :window_height, :window_width, :window_length

  # NOTE: Singleton gem does not allow us to initialize
  # our objects. We can either create our own singleton class,
  # pass around a settings variable or initialize it with
  # default values. The last option reduces dependancy injection
  # potential.
  #
  # NOTE 2: We'll have to call Settings.is_valid? as contracts
  # in other functions. Just not this one.
  def initialize

    @valid_game_type = [:Single, :Multi]
    @valid_game_mode = [:Connect4, :TOOT]
    @valid_themes = [:Default]
    # @valid_number_of_players = [1, 2]

    @game_type = :Single
    @game_mode = :Connect4
    @theme = :Default
    @window_width = 12
    @window_height = 34
    # @number_of_players = 1

    assert valid?
  end

  def valid?
    #class invariant

    return false unless @valid_game_type.include? @game_type
    return false unless @valid_game_mode.include? @game_mode
    return false unless @valid_themes.include? @theme

    return false unless @window_width.is_a? Integer
    return false unless @window_width > 0 and @windowLength <= 1080

    return false unless @window_height.is_a? Integer
    return false unless @window_height > 0 and @window_height <= 1080

    return true
  end

  def to_s
    "Game Type: " + @game_type.to_s + "\n" +
    "Game Mode: " + @game_mode.to_s + "\n" +
    "Theme: " + @theme.to_s + "\n" +
    # "Number of players: " + @number_of_players.to_s + "\n" +
    "Resolution: " + @window_width.to_s + "x" + @window_height.to_s
  end

end

# test = Settings.instance
# puts test.gameType
#
# test.gameType = "Not valid"
# puts test.gameType
