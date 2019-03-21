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
  #
  # NOTE 2: We'll have to call Settings.is_valid? as contracts
  # in other functions. Just not this one.
  def initialize

    @validGameType = ["Connect4", "TOOT"]
    @validGameMode = ["Single", "Multi"]
    @validColors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Black"]

    @gameType = "Connect4"
    @gameMode = "Single"
    @color = "Red"
    @windowWidth = 12
    @windowHeight = 34

    is_valid?

  end

  def is_valid?
    #class invariant

    assert @validGameType.include? @gameType
    assert @validGameMode.include? @gameMode
    assert @validColors.include? @color

    assert @windowWidth.is_a? Numeric
    assert @windowWidth > 0 and @windowLength <= 1080

    assert @windowHeight.is_a? Numeric
    assert @windowHeight > 0 and @windowHeight <= 1080

  end

end

# test = Settings.instance
# puts test.gameType
#
# test.gameType = "Not valid"
# puts test.gameType