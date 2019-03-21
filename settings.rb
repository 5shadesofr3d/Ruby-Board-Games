require 'singleton'
require "test/unit"

class Settings
  include Test::Unit::Assertions
  include Singleton

  attr_accessor :gameType, :gameMode
  attr_accessor :color
  attr_accessor :windowHeight, :windowWidth, :windowLength

  # NOTE: Singleton gem does not allow us to initialize
  # our objects. We can either create our own singleton class,
  # pass around a settings variable or initialize it with
  # default values. The last option reduces dependancy injection
  # potential.
  def initialize

    @validGameType = ["Connect4", "TOOT"]
    @validGameMode = ["Single", "Multi"]
    @validColors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]

    @gameType = "Connect4"
    @gameMode = "Single"
    @color = "Red"
    @windowWidth = 12
    @windowHeight = 34

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

  def getGameType()
    assert is_valid?
    return @gameType
  end

  def getGameMode()
    assert valid?
    return @gameMode
  end

  def getColor()
    assert valid?
    return @color
  end

  def getWindowWidth()
    assert valid?
    return @windowWidth
  end

  def getWindowHeight()
    assert valid?
    return @windowHeight
  end

  def setGameType(gameType)
    assert valid?
    assert gameType.in? @validGameType

    @gameType = gameType
    assert valid?
  end

  def setGameMode(gameMode)
    assert valid?
    assert gameMode.in? @validGameMode

    @gameMode = gameMode
    assert valid?
  end

  def setColor(color)
    assert valid?
    assert color.in? @validColors

    @color = color
    assert valid?
  end

  def setWindowWidth(windowWidth)
    assert valid?
    assert windowWidth.is_a? Numeric
    assert windowWidth > 0 and windowLength <= 1080

    @windowWidth = windowWidth
    assert valid?
  end

  def setWindowHeight(windowHeight)
    assert valid?
    assert windowHeight.is_a? Numeric
    assert windowHeight > 0 and windowHeight <= 1080

    @windowHeight = windowHeight
    assert valid?
  end
end

test = Settings.instance