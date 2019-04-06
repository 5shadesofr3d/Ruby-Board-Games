require "xmlrpc/client"
require "test/unit"
require 'state_pattern'
require 'Qt'

require_relative '../settings'
require_relative '../settings/interface'
require_relative '../title'

require_relative '../game'


class TitleScreenState < StatePattern::State
  include Test::Unit::Assertions

  def valid?
    return false unless @title.is_a? TitleController
    return true
  end

  def enter
    #no preconditions as setup is performed here
    assert stateful.main_window.is_a? Qt::MainWindow

    @title = TitleController.new(self,stateful.main_window)

    assert @title.is_a? TitleController

    assert valid?
  end

  def open_settings
    assert valid?

    transition_to(SettingsScreenState)

    assert valid?
  end

  def open_game
    assert valid?

    stateful.main_window.centralWidget.close if stateful.main_window.centralWidget != nil
    transition_to(GameScreenState)

    assert valid?
  end

end

class TitleController < Qt::Widget
  include Test::Unit::Assertions

  slots 'play_game()', 'multiplayer()', 'open_settings()','quit_game()'

  def initialize(state, window)
    assert state.is_a? TitleScreenState
    assert window.is_a? Qt::MainWindow
    super()

    @state = state
    @window = window

    settings = Settings.instance
    @title = Title.new(settings.window_width,
                       settings.window_height, window)

    connect(@title.bPlay,  SIGNAL('clicked()'), self, SLOT('play_game()'))
    connect(@title.bMultiplayer, SIGNAL('clicked()'), self, SLOT('multiplayer()'))
    connect(@title.bSettings,  SIGNAL('clicked()'), self, SLOT('open_settings()'))
    connect(@title.bQuit,  SIGNAL('clicked()'), $qApp, SLOT('quit()'))

    assert @state.is_a? TitleScreenState
    assert @window.is_a? Qt::MainWindow
    assert @title.is_a? Title
  end

  def open_settings
    assert @state.is_a? TitleScreenState
    assert @title.is_a? Title

    @title.close
    @state.open_settings

    assert @title.visible == false
  end

  def multiplayer

    client = XMLRPC::Client.new( "localhost", "/", 1234 )

    #result, s = client.call2("sample.sum_and_difference", 5, 3)
    #puts s, result

    # Connect to the lobby as user1.
    puts client.call('sample.lobby_connect','user1')

    #client.call("sample.lobby")

    # Join a lobby,
    # busy wait for additional players for our game.
    while client.call("sample.players") < 2
      sleep(2) # Try not to spam the server.
    end

    # Random start times, they should still be synchronized
    # since we busy wait on the server. Successful synchronization!
    #
    # This can be replaced with a button to say start instead.
    sleep(rand(10))
    client.call2("sample.ready")

    while not client.call("sample.is_ready")
      sleep(0.5)
    end

    # Print our current lobby.
    puts client.call2("sample.lobby")
    puts client.call2("sample.super_int")
    puts "Game...start!"

    # Launch the game.

  end

  def play_game
    assert @state.is_a? TitleScreenState
    assert @title.is_a? Title

    @title.close
    @state.open_game

    assert @title.visible == false
  end

end

class GameScreenState < StatePattern::State
  include Test::Unit::Assertions

  def valid?
    return false unless @game.is_a? Game
    return true
  end

  def enter
    # Add the assertions from the game as before.
    assert stateful.main_window.is_a? Qt::MainWindow
    assert Settings.instance.valid?

    @game = nil
    settings = Settings.instance

    case settings.game_mode
    when :Connect4
      @game = Connect4.new(rows: settings.num_rows,
                           columns: settings.num_cols,
                           height: settings.window_height,
                           width: settings.window_width,
                           parent: stateful.main_window)
    when :TOOT
      @game = OTTO.new(rows: settings.num_rows,
                       columns: settings.num_cols,
                       height: settings.window_height,
                       width: settings.window_width,
                       parent: stateful.main_window)
    end

    @game.start
    @game.show
    @game.set_state(self)

    assert @game.is_a? Game
    assert @game.visible
    assert valid?
  end

  def open_title_screen
    assert valid?

    @game.close
    transition_to(TitleScreenState)

    assert valid?
  end

end

class SettingsController < Qt::Widget
  include Test::Unit::Assertions

  slots 'apply_settings()','cancel()'

  def initialize(state, gui, parent=nil)
    assert gui.is_a? SettingsGUI
    assert state.is_a? SettingsScreenState
    super()

    @state = state
    @gui = gui
    @settings = Settings.instance
    connect(@gui.applyButton,  SIGNAL('clicked()'), self, SLOT('apply_settings()'))
    connect(@gui.cancelButton,  SIGNAL('clicked()'), self, SLOT('cancel()'))

    assert @settings.is_a? Settings
    assert @gui.is_a? SettingsGUI
    assert @state.is_a? SettingsScreenState
  end

  def apply_settings
    assert @settings.is_a? Settings

    @settings.theme_setting =  @gui.themeComboBox.currentText.to_sym
    @settings.window_mode = @gui.windowModeComboBox.currentText.to_sym

    @settings.theme = Theme.new(@settings.theme_setting)

    @settings.num_cols = @gui.colSpinBox.value
    @settings.num_rows = @gui.rowSpinBox.value

    if @gui.gameModeComboBox.currentText == "Connect 4"
      @settings.game_mode = :Connect4
    elsif @gui.gameModeComboBox.currentText == "OTTO/TOOT"
      @settings.game_mode = :TOOT
    end

    if @gui.resolutionComboBox.currentText == "800x700"
      @settings.window_width = 800
      @settings.window_height = 700
    elsif @gui.resolutionComboBox.currentText == "1200x1050"
      @settings.window_width = 1200
      @settings.window_height = 1050
    elsif @gui.resolutionComboBox.currentText == "1920x1080"
      @settings.window_width = 1920
      @settings.window_height = 1080
    end

    puts @settings.to_s
    @settings.save_settings

    @gui.close
    @state.open_title

    assert [:TOOT, :Connect4].include? @settings.game_mode
    assert @settings.window_width > 0
    assert @settings.window_height > 0
    assert self.visible == false
  end

  def cancel
    assert @state.is_a? SettingsScreenState

    @gui.close
    @state.open_title

    assert self.visible == false
  end

end

class SettingsScreenState < StatePattern::State
  include Test::Unit::Assertions

  def valid?
    return false unless @controller.is_a? SettingsController
    return true
  end

  def enter
    assert stateful.main_window.is_a? Qt::MainWindow

    settings = Settings.instance

    @settings_gui = SettingsGUI.new(settings.window_width,
                                    settings.window_height,
                                    stateful.main_window)
    @settings_gui.show
    @controller = SettingsController.new(self,
                                         @settings_gui)

    assert @controller.is_a? SettingsController
    assert valid?
  end

  def open_title
    assert valid?

    transition_to(TitleScreenState)

    assert valid?
  end

end

class ApplicationStateMachine < Qt::Widget
  include StatePattern
  include Test::Unit::Assertions
  attr_accessor :window, :main_window
  set_initial_state(TitleScreenState)
  slots 'open_title_screen()'

  def valid?
    return false unless @main_window.height > 0
    return false unless @main_window.width > 0
    return false unless @window.is_a? QTApplication
    return false unless @main_window.is_a? Qt::MainWindow
    return true
  end

  # Create GUI here.
  def initialize
    super

    @window = QTApplication.instance
    @main_window = Qt::MainWindow.new

    settings = Settings.instance
    @main_window.setFixedSize(settings.window_width, settings.window_height)
    @main_window.setWindowTitle("Ruby-Board-Games")

    @main_window.show#show title
    open_title_screen #init title screen

    assert @window.is_a? QTApplication
    assert @main_window.is_a? Qt::MainWindow
    assert @main_window.width > 0
    assert @main_window.height > 0
    assert @main_window.visible
    assert valid?
  end

  # Callback:
  def open_title_screen
    assert valid?

    transition_to(TitleScreenState)

    assert valid?
  end

end
