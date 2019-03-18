class Connect4 < Game
  def initialize(settings)
    assert settings.is_a? Settings
    @settings = settings

    @windowWidth = @settings.getWindowLength()
    @windowHeight = @settings.getWindowHeight()
    @color = @settings.getColor()
    @gameMode = @settings.getGameMode()
    @gameType = @settings.getGameType()

    assert valid?
  end

  def gameAlgorithm()
    assert valid?
  end

  def valid?
    @windowWidth.is_a? Numeric
    @windowWidth > 0 and @windowWidth <= 1080

    @windowHeight.is_a? Numeric
    @windowHeight > 0 and @windowHeight <= 1080

    @gameMode == "Connect4"

    @gameType == "Single" or @gameType == "Multi"

  end
end

class OTTO < Game
  def initialize(settings)
    assert settings.is_a? Settings
    @settings = settings

    @windowLength = @settings.getWindowLength()
    @windowHeight = @settings.getWindowHeight()
    @color = @settings.getColor()
    @gameMode = @settings.getGameMode()
    @gameType = @settings.getGameType()

    assert valid?
  end

  def gameAlgorithm()
    assert valid?
  end

  def valid?
    @windowWidth.is_a? Numeric
    @windowWidth > 0 and @windowWidth <= 1080

    @windowHeight.is_a? Numeric
    @windowHeight > 0 and @windowHeight <= 1080

    @gameMode == "Connect4"

    @gameType == "Single" or @gameType == "Multi"
  end
end