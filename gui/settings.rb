require 'singleton'
require "test/unit"
require_relative '../theme'

class Settings
  include Test::Unit::Assertions
  include Singleton

  attr_accessor :game_type, :game_mode
  attr_accessor :theme, :theme_setting
  attr_accessor :window_height, :window_width, :window_length

  # NOTE 2: We'll have to call Settings.is_valid? as contracts
  # in other functions. Just not this one.
  def initialize

    @valid_game_mode = [:Connect4, :TOOT]
    @valid_themes = [:Default]

    @game_mode = :Connect4
    @theme = Theme.new(:Default)
    @theme_setting = :Default
    @window_width = 800
    @window_height = 600

    assert valid?
  end

  def valid?
    #class invariant

    return false unless @valid_game_mode.include? @game_mode
    return false unless @valid_themes.include? @theme_setting

    return false unless @window_width.is_a? Integer
    return false unless @window_width > 0 and @window_height <= 1080

    return false unless @window_height.is_a? Integer
    return false unless @window_height > 0 and @window_height <= 1080

    return false unless @theme.is_a? Theme

    return true
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

