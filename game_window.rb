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
    assert @windowWidth.is_a? Numeric
    assert @windowWidth > 0 and @windowWidth <= 1080

    assert @windowHeight.is_a? Numeric
    assert @windowHeight > 0 and @windowHeight <= 1080

    assert @gameMode == "Connect4"

    assert @gameType == "Single" or @gameType == "Multi"

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
    assert @windowWidth.is_a? Numeric
    assert @windowWidth > 0 and @windowWidth <= 1080

    assert @windowHeight.is_a? Numeric
    assert @windowHeight > 0 and @windowHeight <= 1080

    assert @gameMode == "Connect4"

    assert @gameType == "Single" or @gameType == "Multi"
  end
end
