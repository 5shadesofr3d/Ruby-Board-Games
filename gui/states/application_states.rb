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

    transition_to(GameScreenState)

    assert valid?
  end

end

#TODO: Get rid of this
class TitleController < Qt::Widget
  include Test::Unit::Assertions

  slots 'play_game()','open_settings()','quit_game()'

  def initialize(state,window)
    assert state.is_a? TitleScreenState
    assert window.is_a? Qt::MainWindow
    super()

    @state = state
    @window = window

    @title = Title.new(800,600,window) #TODO: Dynamic screen size

    connect(@title.bPlay,  SIGNAL('clicked()'), self, SLOT('play_game()'))
    connect(@title.bSettings,  SIGNAL('clicked()'), self, SLOT('open_settings()'))
    connect(@title.bQuit,  SIGNAL('clicked()'), $qApp, SLOT('quit()'))

    assert @state.is_a? TitleScreenState
    assert @window.is_a? Qt::MainWindow
    assert @title.is_a? Title
    assert @title.visible
  end

  def open_settings
    assert @state.is_a? TitleScreenState
    assert @title.is_a? Title

    @title.close
    @state.open_settings

    assert @title.visible == false
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
    assert Settings.instance.game_mode == :Connect4 or Settings.instance.game_mode == :TOOT

    @game = nil
    case Settings.instance.game_mode
    when :Connect4
      @game = Connect4.new(parent: stateful.main_window)
    when :TOOT

    end

    assert @game.is_a?(Game)

    @game.start
    @game.show

    assert @game.is_a? Game
    assert @game.visible
    assert @game.players > 0
    assert valid?
  end

  def open_title_screen
    assert valid?

    transition_to(TitleScreenState)

    assert valid?
  end

end

class SettingsController < Qt::Widget
  slots 'apply_settings()','cancel()'

  def initialize(state,gui)
    super()
    assert gui.is_a? SettingsGUI
    assert state.is_a? SettingsScreenState

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

    assert @settings.game_mode == :Connect4 or @settings.game_mode == :TOOT
    assert @settings.game_type == :Single or @settings.game_type == :Multi
    assert @settings.window_width > 0
    assert @settings.window_height > 0
    assert self.visible == false
  end

  def cancel
    assert @state.is_a? SettingsScreenState

    self.close
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
    assert stateful.settings_gui.is_a? SettingsGUI
    assert stateful.main_window.is_a? Qt::MainWindow

    stateful.settings_gui.setupUi(stateful.main_window)
    @controller = SettingsController.new(self, stateful.settings_gui)

    asset @controller.is_a? SettingsController
    assert valid?
  end

  def open_title
    assert valid?

    transition_to(TitleScreenState)

    assert stateful.state.is_a? TitleScreenState #TODO: Test this
    assert valid?
  end

end

class ApplicationStateMachine < Qt::Widget
  include StatePattern
  include Test::Unit::Assertions
  attr_accessor :window, :settings_gui, :main_window
  set_initial_state(TitleScreenState)
  slots 'open_title_screen()'

  def valid?
    return false unless @main_window.height > 0
    return false unless @main_window.width > 0
    return false unless @main_window.visible
    return false unless @window.is_a? QTApplication
    return false unless @main_window.is_a? Qt::MainWindow
    return true
  end

  # Create GUI here.
  def initialize
    super

    @window = QTApplication.instance
    @settings_gui = SettingsGUI.new
    @main_window = Qt::MainWindow.new
    @main_window.setFixedSize(800,600) #TODO: Set to a dynamic size

    open_title_screen #init title screen

    @main_window.show #show title

    assert @window.is_a? QTApplication
    assert @main_window.is_a? Qt::MainWindow
    assert @main_window.width > 0
    assert @main_window.height > 0
    assert @main_window.visible
    assert valid?
  end

  # Callback:
  def open_title_screen # TODO...
    assert valid?

    transition_to(TitleScreenState)

    assert valid?
  end

end
