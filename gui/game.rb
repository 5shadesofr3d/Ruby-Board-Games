require 'Qt'
require_relative 'board/board'
require_relative 'state/game_states'

class Game < Qt::Widget
  include Test::Unit::Assertions

  attr_reader :board, :lobby, :state, :players

  def initialize(rows: 7, columns: 8, width: 800, height: 600, parent: nil)
    assert rows.is_a?(Integer) and rows > 0
    assert columns.is_a?(Integer) and columns > 0
    assert width.is_a?(Integer) and width >= 300
    assert height.is_a?(Integer) and  height >= 300

    parent != nil ? super(parent) : super()
    resize(width, height)
    setupUI

    @players = []
    @state = GameStateMachine.new(self)

    assert valid?
  end

  def setupUI()
    setupStack
    setupLobby
    setupBoard
  end

  def setupStack()
    @stack = Qt::StackedLayout.new(self)
    setLayout(@stack)
  end

  def setupBoard()
    @board = Board.new(7, 8, parent: self)
    @stack.addWidget(board)
  end

  def setupLobby()
    @lobby = PlayerLobby.new(parent: self)
    w = Qt::Widget.new(self)
    hlayout = Qt::HBoxLayout.new(w)
    hlayout.addWidget(lobby)
    w.setLayout(hlayout)
    @stack.addWidget(w)
  end

  def status()
    raise NotImplementedError
  end

  def addPlayer(player)
    assert Player.is_a?(Player)
    @players << player
  end

  def valid?()
    return false unless @board == nil or @board.is_a?(Board)
    return false unless @stack.is_a?(Qt::StackedLayout)

    return true
  end

end

class Connect4 < Game
  def initialize(rows: 7, columns: 8, width: 800, height: 600, parent: nil)
    super(rows: rows, columns: columns, width: width, height: height, parent: parent)
  end

  def consecutive4?(chips)
    return (chips.size == 4 and chips.uniq.length == 1)
  end

  def status()
    assert valid?

    # check every column first for a "4 in a row"
    board.columns.each do |col|
      cols = board.to_enum(:each_in_column, :chip, col)
      cols.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    # check every row
    board.rows.each do |row|
      rows = board.to_enum(:each_in_column, :chip, row)
      rows.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    # check every diagonal
    board.diagonals.each do |diagonal|
      upper_diag = board.to_enum(:each_in_diagonal, :chip, diagonal, :up)
      upper_diag.each_cons(4) { |chips| return chips if consecutive4?(chips) }

      lower_diag = board.to_enum(:each_in_diagonal, :chip, diagonal, :down)
      lower_diag.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    assert valid?
  end

  def valid?
    return false unless super

    return true
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
