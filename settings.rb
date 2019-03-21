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

    @valid_game_type = ["Connect4", "TOOT"]
    @valid_game_mode = ["Single", "Multi"]
    @valid_themes = ["Default", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]
    @valid_number_of_players = [1, 2]

    @game_type = "Connect4"
    @game_mode = "Single"
    @theme = "Red"
    @window_width = 12
    @window_height = 34
    @number_of_players = 1

    is_valid?

  end

  def is_valid?
    #class invariant

    assert @valid_game_type.include? @game_type
    assert @valid_game_mode.include? @game_mode
    assert @valid_themes.include? @theme

    assert @window_width.is_a? Numeric
    assert @window_width > 0 and @windowLength <= 1080

    assert @window_height.is_a? Numeric
    assert @window_height > 0 and @window_height <= 1080

  end

  def to_s
    "Game Type: " + @game_type + "\n" +
    "Game Mode: " + @game_mode + "\n" +
    "Theme: " + @theme + "\n" +
    "Number of players: " + @number_of_players + "\n" +
    "Resolution: " + @window_width.to_s + "x" + @window_height.to_s
  end

end

# test = Settings.instance
# puts test.gameType
#
# test.gameType = "Not valid"
# puts test.gameType