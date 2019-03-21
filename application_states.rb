require "test/unit"
require 'state_pattern'
require 'Qt'
require_relative 'qt_application'
require_relative 'settings'
require_relative 'gui/settings_gui'

# TODO:
# The state_pattern already defines an abstract state that we inherit
# from, do we need contracts for it?

class TitleScreenState < StatePattern::State
  include Test::Unit::Assertions

  def is_valid?
    assert @window.height > 0
    assert @window.width > 0
    assert @window.visible
    assert @window.is_a? QTApplication
  end

  def enter
    is_valid?

    puts 'Hello, world.'
    # launch the QT applications.


    is_valid?
  end

  def open_settings
    transition_to(SettingsScreenState)
  end

  def open_game
    transition_to(GameScreenState)
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

class SettingsScreenState < StatePattern::State
  include Test::Unit::Assertions

  def is_valid?
    # assert @window.height > 0
    # assert @window.width > 0
    # assert @window.visible
    assert @window.is_a? QTApplication
  end

  def enter
    is_valid?


    is_valid?
  end

  def open_title_screen
    transition_to(TitleScreenState)
  end

end

# Base application state, defines and creates the window here.
class ApplicationStateMachine < Qt::Widget
  include StatePattern
  include Test::Unit::Assertions
  attr_accessor :window
  set_initial_state(SettingsScreenState)
  slots 'go_to_titlescreen()', 'apply_settings()'

  def is_valid?
    # assert @window.height > 0
    # assert @window.width > 0
    # assert @window.visible
    # assert @window.is_a? QTApplication
  end

  # Create GUI here.
  def initialize
    super
    # Use a singleton to create the QT GUI.
    @window = QTApplication.instance
    @settings = Settings.instance
    @gui = SettingsGUI.new

    window = Qt::MainWindow.new
    @gui.setup_ui(window)

    # Setup callbacks.
    connect(@gui.cancelButton, SIGNAL('clicked()'), self, SLOT('go_to_titlescreen()'))
    connect(@gui.applyButton,  SIGNAL('clicked()'), self, SLOT('apply_settings()'))

    window.show

    is_valid?
  end

  # Callback:
  # This is the function that should read the attributes from
  # the view and changes the model. In this case, it acts like
  # the controller.
  def go_to_titlescreen
    # transition_to(TitleScreenState)
    exit # TODO: Integrate title screen.
  end

  def apply_settings

    @settings.number_of_players = @gui.numberPlayersComboBox.currentText
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
      @settings.window_height = 700
      @settings.window_width = 700
    end

    puts @settings.to_s

    @settings.is_valid?
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