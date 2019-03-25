require 'singleton'
require "test/unit"
require 'json'
require_relative '../gui/theme'

class Settings
  include Test::Unit::Assertions
  include Singleton

  attr_accessor :game_mode, :num_cols, :num_rows
  attr_accessor :theme, :theme_setting
  attr_accessor :window_height, :window_width, :window_mode
  attr_reader   :valid_game_mode, :valid_themes, :valid_window_mode

  def initialize

    # Note: Assumes the order of items in these valid_... arrays
    # matches the order of the elements in the combo box.
    @valid_game_mode = [:Connect4, :TOOT]
    @valid_themes = [:Default]
    @valid_window_mode = [:Windowed, :Fullscreen]

    # TODO: Load the settings into the GUI
    if File.file?("settings.json")
      tempHash = JSON.parse(IO.read("settings.json"))
      @game_mode = tempHash["game_mode"].to_sym
      @num_cols = tempHash["num_cols"]
      @num_rows = tempHash["num_rows"]
      @window_mode = tempHash["window_mode"].to_sym
      @theme_setting = tempHash["theme_setting"].to_sym
      @window_width = tempHash["window_width"]
      @window_height = tempHash["window_height"]
      puts tempHash
    else
      @game_mode = :Connect4
      @num_cols = 7
      @num_rows = 6
      @window_mode = :Windowed
      @theme_setting = :Default
      @window_width = 800
      @window_height = 600
    end

    @theme = Theme.new(theme_setting)

    assert valid?
  end

  def save_settings
    tempHash = {
        :game_mode => @game_mode,
        :num_cols => @num_cols,
        :num_rows => @num_rows,
        :window_mode => @window_mode,
        :theme_setting => @theme_setting,
        :window_width => @window_width,
        :window_height => @window_height
    }

    File.open("settings.json","w") do |f|
      f.write(tempHash.to_json)
    end
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
