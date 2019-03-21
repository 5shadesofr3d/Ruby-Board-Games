require_relative 'gui/board/board'

class Game
  attr_reader :board

  def initialize(board)
    assert board.is_a?(Board)

    @board = board

    assert valid?
  end

  def status()
    raise NotImplementedError
  end

  def valid?()
    return false unless board.is_a?(Board)

    return true
  end

end

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

  def four_in_a_row?(chips)
    return (chips.size == 4 and chips.uniq.length == 1)
  end

  def status()
    assert valid?

    # check every column first for a "4 in a row"
    board.columns.each do |col|
      cols = board.to_enum(:each_in_column, :chip, col)
      cols.each_cons(4) { |chips| return chips.first if four_in_a_row?(chips) }
    end

    # check every row
    board.rows.each do |row|
      rows = board.to_enum(:each_in_column, :chip, row)
      rows.each_cons(4) { |chips| return chips.first if four_in_a_row?(chips) }
    end

    # check every diagonal
    board.diagonals.each do |diagonal|
      upper_diag = board.to_enum(:each_in_diagonal, :chip, diagonal, :up)
      upper_diag.each_cons(4) { |chips| return chips.first if four_in_a_row?(chips) }

      lower_diag = board.to_enum(:each_in_diagonal, :chip, diagonal, :down)
      lower_diag.each_cons(4) { |chips| return chips.first if four_in_a_row?(chips) }
    end

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
