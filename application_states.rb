require "test/unit"
require 'state_pattern'
require 'Qt'
require_relative 'qt_application'
require_relative 'settings'
require_relative 'gui/settings_gui'
require_relative 'gui/title/title'

require_relative 'gui/board/board'
require_relative 'gui/board/board_item.rb'


class TitleScreenState < StatePattern::State
  include Test::Unit::Assertions

  def valid?
    return false unless @title.is_a? TitleController
    return true
  end

  def enter
    #no preconditions as setup is performed here

    @title = TitleController.new(self,stateful.main_window)

    assert @title.is_a? TitleController

    assert valid?
  end

  def open_settings
    transition_to(SettingsScreenState)
  end

  def open_game
    transition_to(GameScreenState)
  end

  def quit_game
    puts "quit"
    exit
  end

end

#TODO: Get rid of this
class TitleController < Qt::Widget
  include Test::Unit::Assertions

  slots 'play_game()','open_settings()','quit_game()'

  def initialize(state,window)
    assert state.is_a? TitleScreenState
    super()

    @state = state

    @title = Title.new(800,600,window)

    connect(@title.bPlay,  SIGNAL('clicked()'), self, SLOT('play_game()'))
    connect(@title.bSettings,  SIGNAL('clicked()'), self, SLOT('open_settings()'))
    connect(@title.bQuit,  SIGNAL('clicked()'), self, SLOT('quit_game()'))

    assert @title.is_a? Title
  end

  def open_settings
    @title.close
    @state.open_settings
  end

  def play_game
    @title.close
    @state.open_game
  end

  def quit_game
    @title.close
    @state.quit_game
  end

end

class GameScreenState < StatePattern::State
  include Test::Unit::Assertions

  def valid?
    #assert @window.height > 0
    #assert @window.width > 0
    #assert @window.visible
    #assert @window.is_a? QTApplication
  end

  def enter
    # Add the assertions from the game as before.
    board = Board.new(7, 8)

    board.background = Qt::white
    board.color = Qt::Color.new("#48dbfb")

    chip_red = Connect4Chip.new(color: Qt::red, parent: board)
    chip_yellow = Connect4Chip.new(color: Qt::yellow, parent: board)

    chip_t = OTTOChip.new(:T, parent: board)
    chip_o = OTTOChip.new(:O, parent: board)

    chip_red == chip_yellow ? puts("yes") : puts("no")
    chip_t == chip_o ? puts("yes") : puts("no")

    board.insert(chip_yellow, 3)
    board.insert(chip_red, 3)
    board.insert(chip_t, 3)
    board.insert(chip_o, 3)
  end

  def open_title_screen
    transition_to(TitleScreenState)
  end

end

class SettingsController < Qt::Widget
  slots 'apply_settings()','cancel()'

  def initialize(state,gui)
    super()

    @state = state
    @gui = gui
    @settings = Settings.instance
    connect(@gui.applyButton,  SIGNAL('clicked()'), self, SLOT('apply_settings()'))
    connect(@gui.cancelButton,  SIGNAL('clicked()'), self, SLOT('cancel()'))
  end

  def apply_settings

    # @settings.number_of_players = @gui.numberPlayersComboBox.currentText
    @settings.theme =  @gui.themeComboBox.currentText.to_sym

    if @gui.gameModeComboBox.currentText == "Connect 4"
      @settings.game_mode = :Connect4
    elsif @gui.gameModeComboBox.currentText == "OTTO/TOOT"
      @settings.game_mode = :TOOT
    end

    if @gui.gameTypeComboBox.currentText == "Single Player"
      @settings.game_type = :Single
    elsif @gui.gameTypeComboBox.currentText == "Multiplayer"
      @settings.game_type = :Multi
    end

    if @gui.resolutionComboBox.currentText == "400x600"
      @settings.window_height = 400
      @settings.window_width = 600
    end

    puts @settings.to_s

    self.close
    @state.open_title

    @settings.is_valid?
  end

  def cancel
    self.close
    @state.open_title
  end

end

class SettingsScreenState < StatePattern::State
  include Test::Unit::Assertions

  def valid?
    # assert @window.height > 0
    # assert @window.width > 0
    # assert @window.visible
    # assert @window.is_a? QTApplication
  end

  def enter
    valid?
    stateful.settings_gui.setupUi(stateful.main_window)
    @controller = SettingsController.new(self, stateful.settings_gui)
    valid?
  end

  def open_title
    transition_to(TitleScreenState)
  end

end

class ApplicationStateMachine < Qt::Widget
  include StatePattern
  include Test::Unit::Assertions
  attr_accessor :window, :settings_gui, :main_window
  set_initial_state(TitleScreenState)
  slots 'open_title_screen()'

  def is_valid?
    # assert @window.height > 0
    # assert @window.width > 0
    # assert @window.visible
    # assert @window.is_a? QTApplication
  end

  # Create GUI here.
  def initialize
    super

    @window = QTApplication.instance
    @settings_gui = SettingsGUI.new
    # @title_screen_gui = TitleScreenGUI.new
    @main_window = Qt::MainWindow.new
    @main_window.setFixedSize(800,600)
    open_title_screen


    # TODO: Remove later.
  #  transition_to(SettingsScreenState)

    @main_window.show

    is_valid?
  end

  # Callback:
  def open_title_screen # TODO...
    #@title_screen_gui.setup_ui(@main_window)
    transition_to(TitleScreenState)
  end

end

class GameApplication
  include Test::Unit::Assertions

  def is_valid?
    # assert @window.height > 0
    # assert @window.width > 0
    # assert @window.visible
    assert @window.is_a? QTApplication
    assert @state_machine.is_a? ApplicationStateMachine
  end

  # Create GUI here.
  def initialize
    # Use a singleton to create the QT GUI.
    @window = QTApplication.instance
    @settings = Settings.instance
    @state_machine = ApplicationStateMachine.new

    # Setup "connections" for QT to capture mouse clicks.

    # Display the window
    # NOTE: While window is displayed, we're stuck here.
    @window.app.exec
    # When window is closed, we execute the rest of the code.

    is_valid?
  end

  # Main application loop.
  def main
    is_valid?
    # On launch.
    # Display title screen.
    # If settings button clicked from title screen.
    # Open settings screen.
    # If game button clicked from title screen.
    # Open game screen.
    # When game ends.
    # Open title screen.
    is_valid?
  end

  # This gets called whenever a user clicks.
  def call_back

  end

end

sup = GameApplication.new

# a = QTApplication.instance
# hello = Qt::PushButton.new('Hello World!', nil)
# hello.resize(100, 30)
# hello.show()
# a.app.exec()
