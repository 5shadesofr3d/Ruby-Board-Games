class Connect4 < Game
  def initialize(settings)
    assert settings.is_a? Settings
    @settings = settings

    @window_width = @settings.getWindowLength()
    @window_height = @settings.getWindowHeight()
    @color = @settings.getColor()
    @game_mode = @settings.getGameMode()
    @game_type = @settings.getGameType()

    assert valid?
  end

  def gameAlgorithm()
    assert valid?
  end

  def valid?
    @window_width.is_a? Numeric
    @window_width > 0 and @window_width <= 1080

    @window_height.is_a? Numeric
    @window_height > 0 and @window_height <= 1080

    @game_mode == "Connect4"

    @game_type == "Single" or @game_type == "Multi"

  end
end

class OTTO < Game
  def initialize(settings)
    assert settings.is_a? Settings
    @settings = settings

    @windowLength = @settings.getWindowLength()
    @window_height = @settings.getWindowHeight()
    @color = @settings.getColor()
    @game_mode = @settings.getGameMode()
    @game_type = @settings.getGameType()

    assert valid?
  end

  def gameAlgorithm()
    assert valid?
  end

  def valid?
    @window_width.is_a? Numeric
    @window_width > 0 and @window_width <= 1080

    @window_height.is_a? Numeric
    @window_height > 0 and @window_height <= 1080

    @game_mode == "Connect4"

    @game_type == "Single" or @game_type == "Multi"
  end
end
