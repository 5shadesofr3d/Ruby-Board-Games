require "test/unit"
require 'state_pattern'
require_relative 'qt_application'

# TODO:
# The state_pattern already defines an abstract state that we inherit
# from, do we need contracts for it?

# Base application state, defines and creates the window here.
class ApplicationStateMachine
  include StatePattern
  attr_accessor :window
  set_initial_state(TitleScreenState)

  def is_valid?
    assert @window.height > 0
    assert @window.width > 0
    assert @window.visible
    assert @window.is_a? QTApplication
  end

  # Create GUI here.
  def initialize
    # Use a singleton to create the QT GUI.
    @window = QTApplication.instance

    is_valid?
  end


end

class GameApplication

  def is_valid?
    assert @window.height > 0
    assert @window.width > 0
    assert @window.visible
    assert @window.is_a? QTApplication
    assert @state_machine.is_a? ApplicationStateMachine
  end

  # Create GUI here.
  def initialize
    # Use a singleton to create the QT GUI.
    @window = QTApplication.instance
    @state_machine = ApplicationStateMachine.new

    # Setup "connections" for QT to capture mouse clicks.

    # Display the window

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

class TitleScreenState < StatePattern::State

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

end

class SettingsScreenState < StatePattern::State

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

  def open_title_screen
    transition_to(TitleScreenState)
  end

end

class GameScreenState < StatePattern::State

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