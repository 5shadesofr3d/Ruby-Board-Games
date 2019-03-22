require "test/unit"
require 'state_pattern'
require 'Qt'
require_relative 'qt_application'
require_relative 'settings'
require_relative 'gui/settings_gui'
require_relative 'gui/title/title'

# TODO:
# The state_pattern already defines an abstract state that we inherit
# from, do we need contracts for it?

class TitleScreenState < StatePattern::State

  def initialize()
    super()

    @title = TitleController.new(self)

    assert @title.is_a? TitleController
  end


  def is_valid?
    assert @window.height > 0
    assert @window.width > 0
    assert @window.visible
    assert @window.is_a? QTApplication
  end

  def enter
    is_valid?
    # assert class invariants?
    is_valid?
  end

  def open_settings
    transition_to(SettingsScreenState)
  end

  def open_game
    transition_to(GameScreenState)
  end

  def quit_game
    puts "quit"
  end

end

#TODO: Get rid of this
class TitleController < Qt::Widget
  slots 'play_game()','open_settings()','quit_game()'

  def initialize(state)
    assert state.is_a? TitleScreenState
    super()

    @state = state

    @title = Title.new

    connect(@title.bPlay,  SIGNAL('clicked()'), self, SLOT('play_game()'))
    connect(@title.bSettings,  SIGNAL('clicked()'), self, SLOT('open_settings()'))
    connect(@title.bQuit,  SIGNAL('clicked()'), self, SLOT('quit_game()'))

    assert @title.is_a? Title
  end

  def open_settings
    @state.open_settings
  end

  def open_game
    @state.open_game
  end

  def quit_game
    @state.quit_settings
  end

end

class GameScreenState < StatePattern::State
  include Test::Unit::Assertions

  def is_valid?
    assert @window.height > 0
    assert @window.width > 0
    assert @window.visible
    assert @window.is_a? QTApplication
  end

  def enter
    is_valid?
    # Add the assertions from the game as before.
    is_valid?
  end

  def open_title_screen
    transition_to(TitleScreenState)
  end

end

class SettingsController < Qt::Widget
  slots 'apply_settings()'

  def initialize(gui)
    super()

    @gui = gui
    @settings = Settings.instance

    connect(@gui.applyButton,  SIGNAL('clicked()'), self, SLOT('apply_settings()'))

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

    @settings.is_valid?
  end

end

class SettingsScreenState < StatePattern::State
  include Test::Unit::Assertions

  def initialize()
    super()

    @title = TitleController.new(self)

    assert @Title.is_a? TitleController
  end


  def is_valid?
    # assert @window.height > 0
    # assert @window.width > 0
    # assert @window.visible
    # assert @window.is_a? QTApplication
  end

  def enter
    is_valid?
    @controller = SettingsController.new(stateful.settings_gui)
    is_valid?
  end

end

class ApplicationStateMachine < Qt::Widget
  include StatePattern
  include Test::Unit::Assertions
  attr_accessor :window, :settings_gui
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

    @settings_gui.setup_ui(@main_window)

    # Setup callbacks.
    connect(@settings_gui.cancelButton, SIGNAL('clicked()'), self, SLOT('open_title_screen()'))

    # TODO: Remove later.
    transition_to(SettingsScreenState)

    @main_window.show

    is_valid?
  end

  # Callback:
  def open_title_screen # TODO...
    #@title_screen_gui.setup_ui(@main_window)
    #transition_to(TitleScreenState)
    exit
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
