require 'singleton'
require "test/unit"
require_relative '../theme'

class Settings
  include Test::Unit::Assertions
  include Singleton

  attr_accessor :game_mode, :num_cols, :num_rows
  attr_accessor :theme, :theme_setting
  attr_accessor :window_height, :window_width, :window_mode

  # NOTE 2: We'll have to call Settings.is_valid? as contracts
  # in other functions. Just not this one.
  def initialize

    @valid_game_mode = [:Connect4, :TOOT]
    @valid_themes = [:Default]
    @valid_window_mode = [:Windowed, :Fullscreen]

    @game_mode = :Connect4
    @num_cols = 7
    @num_rows = 6
    @theme = Theme.new(:Default)
    @window_mode = :Windowed
    @theme_setting = :Default
    @window_width = 800
    @window_height = 600

    assert valid?
  end

  def valid?
    #class invariant

    return false unless @valid_game_mode.include? @game_mode
    return false unless @valid_themes.include? @theme_setting
    return false unless @valid_window_mode.include? @window_mode

    return false unless @window_width.is_a? Integer
    return false unless @window_width > 0 and @window_height <= 1080

    return false unless @window_height.is_a? Integer
    return false unless @window_height > 0 and @window_height <= 1080

    return false unless @num_cols.is_a? Integer and @num_rows.is_a? Integer
    return false unless @num_cols > 0 and @num_rows > 0

    return false unless @theme.is_a? Theme

    return true
  end

  def to_s
    "Game Mode: " + @game_mode.to_s + "\n" +
    "Board Size: Rows: #{@num_rows} Cols: #{@num_cols}\n" +
    "Window Mode: #{@window_mode}\n" +
    "Resolution: #{@window_width}x#{@window_height}\n" +
    "Theme: #{@theme_setting}\n"
  end

end
