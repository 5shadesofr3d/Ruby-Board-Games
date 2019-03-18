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

  # Create GUI here.
  def initialize
    # assert Window.Size > 0
    # assert Window.Displayed = true
    # assert application.is_a? QTWindow

    # @window = ...
  end

end

class TitleScreenState < StatePattern::State

  def enter
    # assert class invariants?
  end

  def open_settings
    # transition_to(SettingsState)
  end

  def open_game
    # transition_to(GameState)
  end

end
