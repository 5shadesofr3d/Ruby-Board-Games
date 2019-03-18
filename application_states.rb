require "test/unit"
require 'state_pattern'

# TODO:
# The state_pattern already defines an abstract state that we inherit
# from, do we need contracts for it>


# Base application state, defines and creates the window here.
class ApplicationState
  include StatePattern
  # attr_accessor :window
  set_initial_state(TitleScreenState)

  def is_valid?
    # assert Window.Size > 0
    # assert Window.Displayed = true
    # assert application.is_a? QTWindow
  end

  # Create GUI here.
  def initialize
    # Use a singleton to create the QT GUI.
    # @window = ...
  end

  # Main application loop.
  def main

    # Display title screen.
    # If settings button clicked.
    # Open settings screen.
    # If game button clicked.
    # Open game screen.
  end

end

class TitleScreenState < StatePattern::State

  def enter
    # assert class invariants?
  end

  def open_settings
    transition_to(SettingsScreenState)
  end

  def open_game
    transition_to(GameScreenState)
  end

end

class SettingsScreenState < StatePattern::State

  def enter
    # assert class invariants?
  end

  def open_title_screen
    transition_to(TitleScreenState)
  end

end

class GameScreenState < StatePattern::State

  def enter
    # assert class invariants?
  end

  def open_title_screen
    transition_to(TitleScreenState)
  end

end