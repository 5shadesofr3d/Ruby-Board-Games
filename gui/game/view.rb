require 'Qt'
require_relative 'model'
require_relative '../board'
require_relative '../player'
require_relative '../debug'
require_relative '../lobby/view'
require_relative '../states/game_states'

module Game
  class View < Qt::Widget
    include Test::Unit::Assertions
    include Debug

    attr_reader :lobby, :board

    signals "keyPressed(const QKeyEvent*)"

    def initialize(rows, columns, width: 800, height: 600, parent: nil)

      assert rows.is_a?(Integer) and rows > 0
      assert columns.is_a?(Integer) and columns > 0
      assert width.is_a?(Integer) and width >= 300
      assert height.is_a?(Integer) and  height >= 300

      parent != nil ? super(parent) : super()
      resize(width, height)

      setupUI(rows, columns)

      assert width() == width
      assert height() == height
    end

    def setupUI(rows, cols)
      setupStack
      setupLobby
      setupBoard(rows, cols)

      setFocus(Qt::OtherFocusReason)
      setFocusPolicy(Qt::StrongFocus)
    end

    def update(model)
      
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
      @board = Board::View.new(rows, cols, parent: self)
      @stack.addWidget(@board)
    end

    def setupLobby()
      @lobby = Lobby::View.new(parent: self)

      @lobbyWidget = Qt::Widget.new(self)
      hlayout = Qt::HBoxLayout.new(@lobbyWidget)
      hlayout.addWidget(@lobby)
      @lobbyWidget.setLayout(hlayout)
      @stack.addWidget(@lobbyWidget)

      assert @lobby.table.rows.count >= 0
    end

    def showLobby()
      assert @lobbyWidget.is_a? Qt::Widget
      @stack.setCurrentWidget(@lobbyWidget)
    end

    def showBoard()
      assert @board.is_a? Qt::Widget
      @stack.setCurrentWidget(@board)
    end
  end
end
