require 'Qt'
require_relative 'board'
require_relative 'states/game_states'
require_relative 'debug'

class Game < Qt::Widget
  include Test::Unit::Assertions
  include Debug
  attr_reader :board, :lobby, :machine, :players

  signals "keyPressed(const QKeyEvent*)"

  def initialize(rows: 7, columns: 8, width: 800, height: 600, parent: nil)
    assert rows.is_a?(Integer) and rows > 0
    assert columns.is_a?(Integer) and columns > 0
    assert width.is_a?(Integer) and width >= 300
    assert height.is_a?(Integer) and  height >= 300

    parent != nil ? super(parent) : super()
    resize(width, height)
    setupUI

    @players = []
    @machine = GameStateMachine.new(self)

    assert valid?
  end

  def setupUI()
    setupStack
    setupLobby
    setupBoard

    setFocus(Qt::OtherFocusReason)
    setFocusPolicy(Qt::StrongFocus)
  end

  def keyPressEvent(event)
    assert event.is_a?(Qt::KeyEvent)
    super(event)
    keyPressed(event) # signal
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
    @lobbyWidget = Qt::Widget.new(self)
    hlayout = Qt::HBoxLayout.new(@lobbyWidget)
    hlayout.addWidget(lobby)
    @lobbyWidget.setLayout(hlayout)
    @stack.addWidget(@lobbyWidget)
    @lobby.addPlayer() # we have at least 1 player
    assert @lobby.room.playerInfos.count > 0
  end

  def start()
    machine.setup()
    machine.start()
  end

  def set_state(state)
    @statem = state
  end

  def stop()
    machine.stop
    @statem.open_title_screen
  end

  def showLobby()
    assert @lobbyWidget.is_a? Qt::Widget
    @stack.setCurrentWidget(@lobbyWidget)
  end

  def showBoard()
    assert @board.is_a? Qt::Widget
    @stack.setCurrentWidget(@board)
  end

  def constructChip(color: c)
    raise NotImplementedError
  end

  def winner?()
    raise NotImplementedError
  end

  def setPlayerGoals()
    raise NotImplementedError
  end

  def updatePlayers()
    @players = lobby.getPlayers()
    players.each { |player| player.game = self }
    setPlayerGoals()
    assert @players.count > 0
  end

  def updatePlayerInfos()
    @lobby.setPlayers(players)
  end

  def addPlayer(player)
    assert Player.is_a?(Player)
    @players << player
    assert @players.include? player
  end

  def valid?()
    return false unless @board == nil or @board.is_a?(Board)
    return false unless @stack.is_a?(Qt::StackedLayout)
    return true
  end

end

class Connect4 < Game
  def initialize(rows: 7, columns: 8, width: 800, height: 600, parent: nil)
    assert rows.is_a? Integer
    assert columns.is_a? Integer
    assert width.is_a? Integer
    assert height.is_a? Integer
    assert columns > 0
    assert rows > 0
    assert width > 0
    assert height > 0

    super(rows: rows, columns: columns, width: width, height: height, parent: parent)
  end

  def constructChip(c)
    chip = Connect4Chip.new(color: c, parent: board)
    chip.geometry = board.model.head(0).geometry # place new chip on the first slot at the top of the board
    return chip
  end

  def consecutive4?(chips)
    assert chips.is_a? Array
    return false unless chips.size == 4
    return false if chips.include?(nil)
    return chips.uniq { |c| c.secondary.name }.length == 1
  end

  def findConsecutive4()
    assert board.model.is_a? BoardModel
    assert valid?

    model = board.model

    # check every column first for a "4 in a row"
    model.columns.each do |col|
      cols = model.to_enum(:each_in_column, :chip, col)
      cols.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    # check every row
    model.rows.each do |row|
      rows = model.to_enum(:each_in_row, :chip, row)
      rows.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    # check every diagonal
    model.diagonals.each do |diagonal|
      upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up)
      upper_diag.each_cons(4) { |chips| return chips if consecutive4?(chips) }

      lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down)
      lower_diag.each_cons(4) { |chips| return chips if consecutive4?(chips) }
    end

    assert valid?

    return []
  end

  def setPlayerGoals()
    players.each { |player| player.goal = Array.new(4, player.color.name) }
  end

  def winner?()
    chips = findConsecutive4()
    players.each { |player| return true if player.goal.size == chips.size && player.goal == chips.map(&:color) } # we have a winner if the chip sequence matches the player's goal
    return false
  end

  def win_goal
    chips = findConsecutive4()
    players.each { |player| return player.color.name if player.goal.size == chips.size && player.goal == chips.map(&:color) } # we have a winner if the chip sequence matches the player's goal
  end

  def valid?
    return false unless super

    return true
  end

end

class OTTO < Game
  @@chip_iteration = 0
  @@otto = [:O, :T, :T, :O]
  @@toot = [:T, :O, :O, :T]

  def initialize(rows: 7, columns: 8, width: 800, height: 600, parent: nil)
    super(rows: rows, columns: columns, width: width, height: height, parent: parent)
    lobby.addPlayer() # minimum 2 players
  end

  def constructChip(c)
    symbol = @@chip_iteration.even?() ? :T : :O
    chip = OTTOChip.new(symbol, color: c, parent: board)
    chip.geometry = board.model.head(0).geometry # place new chip on the first slot at the top of the board
    @@chip_iteration += 1
    return chip
  end

  def consecutiveOTTO?(chips)
    return false unless chips.size == 4
    return false if chips.include?(nil)
    return (chips.map(&:id) == @@otto or chips.map(&:id) == @@toot)
  end

  def findConsecutiveOTTO()
    assert valid?

    model = board.model

    # check every column first for a "4 in a row"
    model.columns.each do |col|
      cols = model.to_enum(:each_in_column, :chip, col)
      cols.each_cons(4) { |chips| return chips if consecutiveOTTO?(chips) }
    end

    # check every row
    model.rows.each do |row|
      rows = model.to_enum(:each_in_row, :chip, row)
      rows.each_cons(4) { |chips| return chips if consecutiveOTTO?(chips) }
    end

    # check every diagonal
    model.diagonals.each do |diagonal|
      upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up)
      upper_diag.each_cons(4) { |chips| return chips if consecutiveOTTO?(chips) }

      lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down)
      lower_diag.each_cons(4) { |chips| return chips if consecutiveOTTO?(chips) }
    end

    assert valid?
    return []
  end

  def winner?
    chips = findConsecutiveOTTO()
    players.each { |player| return true if player.goal.size == chips.size && player.goal == chips.map(&:id) }
    return false
  end

  def setPlayerGoals()
    players.each_with_index { |player, index| player.goal = index.even? ? @@otto : @@toot }
  end

  def valid?
    return false unless super

    return true
  end

end
