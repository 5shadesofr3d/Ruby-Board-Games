class Settings
  include Test::Unit::Assertions
  attr_accessor :gameMode, :gameType
  attr_accessor :color
  attr_accessor :windowLength, :windowHeight, :windowWidth


  def initialize(gameType, gameMode, color, width, height)

    @validGameType = ["Connect4", "TOOT"]
    @validGameMode = ["Single", "Multi"]
    @validColors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]

    @gameType = gameType
    @gameMode = gameMode
    @color = color
    @windowWidth = width
    @windowHeight = height

    assert is_valid?

  end

  def is_valid?
    #class invariant

    assert @gameType.in? @validGameType
    assert @gameMode.in? @validGameMode
    assert @color.in? @validColors

    assert @windowWidth.is_a? Numeric
    assert @windowWidth > 0 and @windowLength <= 1080

    assert @windowHeight.is_a? Numeric
    assert @windowHeight > 0 and @windowHeight <= 1080

  end

end
