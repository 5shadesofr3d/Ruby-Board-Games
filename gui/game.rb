require 'Qt'
require_relative 'board'
require_relative 'states/game_states'
require_relative 'debug'

class Game < Qt::Widget
  include Test::Unit::Assertions
  include Debug
  attr_reader :board, :lobby, :machine, :players

  signals "keyPressed(const QKeyEvent*)"

  def initialize(rows: 7, columns: 8,
                 width: 800, height: 600,
                 players: {"Player": :Local}, lobby_type: GameLobbyState,
                 parent: nil)

    assert rows.is_a?(Integer) and rows > 0
    assert columns.is_a?(Integer) and columns > 0
    assert width.is_a?(Integer) and width >= 300
    assert height.is_a?(Integer) and  height >= 300
    assert players.is_a? Hash

    # players.each do |i|
    #   assert i.is_a? String
    # end

    parent != nil ? super(parent) : super()
    resize(width, height)

    @players = players
    @lobby_type = lobby_type
    @machine = GameStateMachine.new(self)

    setupUI(rows, columns)

    assert width() == width
    assert height() == height
    assert valid?
  end

  def setupUI(rows, cols)
    setupStack
    setupLobby
    setupBoard(rows, cols)

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

  def setupBoard(rows, cols)
    @board = Board.new(rows, cols, parent: self)
    @stack.addWidget(board)
  end

  def setupLobby
    assert true unless @players.nil?

    @lobby = PlayerLobby.new(parent: self)

    # Insert our online players
    @players.each do |player, type|

      @lobby.addPlayer(player.to_s, type)
    end

    @lobbyWidget = Qt::Widget.new(self)
    hlayout = Qt::HBoxLayout.new(@lobbyWidget)
    hlayout.addWidget(lobby)
    @lobbyWidget.setLayout(hlayout)
    @stack.addWidget(@lobbyWidget)

    assert @lobby.room.playerInfos.count > 0
  end

  def start
    machine.setup(@lobby_type)
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

  def constructChip(c, column: 0)
    raise NotImplementedError
  end

  def findGoal()
    # if a goal was found, we have a winner!
    assert board.model.is_a? BoardModel
    assert valid?

    model = board.model

    # check every column first for a "4 in a row"
    model.columns.each do |col|
      cols = model.to_enum(:each_in_column, :chip, col)
      cols.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
    end

    # check every row
    model.rows.each do |row|
      rows = model.to_enum(:each_in_row, :chip, row)
      rows.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
    end

    # check every diagonal
    model.diagonals.each do |diagonal|
      upper_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :up)
      upper_diag.each_cons(4) { |chips| return chips if matchesGoal?(chips) }

      lower_diag = model.to_enum(:each_in_diagonal, :chip, diagonal, :down)
      lower_diag.each_cons(4) { |chips| return chips if matchesGoal?(chips) }
    end

    assert valid?

    return []
  end

  def winner?()
    return winnersGoal != nil
  end

  def tie?()
    model = board.model
    topRow = model.to_enum(:each_in_row, :chip,	0)
    return (!topRow.include?(nil) and !winner?)
  end


  def winnersGoal()
    raise NotImplementedError
  end

  def matchesGoal?(chips)
    raise NotImplementedError
  end

  def setPlayerGoals()
    raise NotImplementedError
  end

  def updatePlayerScores()
    goal = winnersGoal
    if (goal != nil) # a winner was found
      players.each { |player| player.goal == goal ? player.wins += 1 : player.losses += 1 }
    else # we had a tie
      players.each { |player| player.ties += 1 }
    end
  end

  def updatePlayers()
    assert lobby.is_a? PlayerLobby

    @players = lobby.getPlayers()
    players.each { |player| player.game = self }
    setPlayerGoals()

    assert @players.is_a? Array
    @players.each {|e| assert e.goal.is_a? Array}
    @players.each {|e| assert e.is_a? Player}
    assert @players.count > 0
  end

  def updatePlayerInfos()
    @lobby.setPlayers(players)

    assert @lobby.getPlayers.count > 0
  end

  def addPlayer(player)
    assert Player.is_a?(Player)
    @players << player
    assert @players.include? player
  end

  def valid?
    return false unless @board == nil or @board.is_a?(Board)
    return false unless @stack.is_a?(Qt::StackedLayout)
    return true
  end

  def getNumberOfPlayers()
    assert valid?
  end

  def getRows()
    assert valid?
  end

  def getCols()
    assert valid?
  end

  def getHeight()
    assert valid?
  end

  def getWidth()
    assert valid?
  end

  def getType()
    assert valid?
  end

  def getColors()
    assert valid?
  end

  def getTurn()
    assert valid?
  end

  def getChips()
    assert valid?
  end

end

class Connect4 < Game
  def initialize(rows: 7, columns: 8,
                 width: 800, height: 600,
                 players: {"Player": :Local}, lobby_type: GameLobbyState,
                 parent: nil)

    assert rows.is_a? Integer
    assert columns.is_a? Integer
    assert width.is_a? Integer
    assert height.is_a? Integer
    assert columns > 0
    assert rows > 0
    assert width > 0
    assert height > 0

    super(rows: rows, columns: columns,
          width: width, height: height,
          players: players, lobby_type: lobby_type,
          parent: parent)
  end

  def constructChip(c, column: 0)
    chip = Connect4Chip.new(color: c, parent: board)
    chip.geometry = board.model.head(0).geometry # place new chip on the first slot at the top of the board
    return chip
  end

  def matchesGoal?(chips)
    assert chips.is_a? Array
    return false unless chips.size == 4
    return false if chips.include?(nil)
    return chips.uniq { |c| c.secondary.name }.length == 1
  end

  def setPlayerGoals
    assert players.is_a? Array
    assert players.size > 0

    players.each { |player| player.goal = Array.new(4, player.color.name) }

    assert players.is_a? Array
    assert players.size > 0
    players.each {|p| assert p.goal.first == p.color.name}
    players.each {|p| assert p.goal.is_a? Array}
    players.each {|p| assert p.goal.size == 4}
  end

  def winnersGoal
    chips = findGoal()
    players.each { |player| return player.goal if player.goal.size == chips.size && player.goal == chips.map(&:color) } # we have a winner if the chip sequence matches the player's goal
    return nil
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

  def initialize(rows: 7, columns: 8,
                 width: 800, height: 600,
                 players: ["Player"], lobby_type: GameLobbyState,
                 parent: nil)

    super(rows: rows, columns: columns,
          width: width, height: height,
          players: players, lobby_type: lobby_type,
          parent: parent)

    lobby.addPlayer # minimum 2 players
  end

  def constructChip(c, column: 0)
    symbol = @@chip_iteration.even?() ? :T : :O
    chip = OTTOChip.new(symbol, color: c, parent: board)
    chip.geometry = board.model.head(column).geometry # place new chip on the first slot at the top of the board
    @@chip_iteration += 1
    return chip
  end

  def matchesGoal?(chips)
    return false unless chips.size == 4
    return false if chips.include?(nil)
    return (chips.map(&:id) == @@otto or chips.map(&:id) == @@toot)
  end

  def winnersGoal()
    chips = findGoal()
    players.each { |player| return player.goal if player.goal.size == chips.size && player.goal == chips.map(&:id) }
    return nil
  end

  def setPlayerGoals()
    players.each_with_index { |player, index| player.goal = index.even? ? @@otto : @@toot }
  end

  def valid?
    return false unless super

    return true
  end

end
