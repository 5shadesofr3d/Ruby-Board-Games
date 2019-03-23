require 'singleton'
require 'Qt'

require_relative 'gui/settings'
require_relative 'gui/states/application'

class QTApplication
  include Singleton
  attr_accessor :app

  def initialize
    @app = Qt::Application.new ARGV
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