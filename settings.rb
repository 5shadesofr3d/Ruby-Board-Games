require 'singleton'
require "test/unit"

class Settings
  include Test::Unit::Assertions
  include Singleton

  attr_accessor :game_type, :game_mode
  attr_accessor :theme
  attr_accessor :window_height, :window_width, :window_length

  # NOTE 2: We'll have to call Settings.is_valid? as contracts
  # in other functions. Just not this one.
  def initialize

    # @valid_game_type = [:Single, :Multi] # TODO: Deprecate this to?
    @valid_game_mode = [:Connect4, :TOOT]
    @valid_themes = [:Default]

    # @game_type = :Single
    @game_mode = :Connect4
    @theme = :Default
    @window_width = 800
    @window_height = 600

    is_valid?

  end

  def is_valid?
    #class invariant

    assert @valid_game_mode.include? @game_mode
    assert @valid_themes.include? @theme

    assert @window_width.is_a? Numeric
    assert @window_width > 0 and @windowLength <= 1080

    assert @window_height.is_a? Numeric
    assert @window_height > 0 and @window_height <= 1080

  end

  def to_s
    "Game Type: " + @game_type.to_s + "\n" +
    "Game Mode: " + @game_mode.to_s + "\n" +
    "Theme: " + @theme.to_s + "\n" +
    "Resolution: " + @window_width.to_s + "x" + @window_height.to_s
  end

end

# test = Settings.instance
# puts test.gameType
#
# test.gameType = "Not valid"
# puts test.gameType