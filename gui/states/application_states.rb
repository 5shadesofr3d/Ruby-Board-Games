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

#TODO: Get rid of this
class TitleController < Qt::Widget
  include Test::Unit::Assertions

  slots 'play_game()','open_settings()','quit_game()'

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
      @game = OTTO.new(parent: stateful.main_window)
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

    if @gui.resolutionComboBox.currentText == "600x800"
      @settings.window_width = 600
      @settings.window_height = 800
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
    #assert stateful.settings_gui.is_a? SettingsGUI
    assert stateful.main_window.is_a? Qt::MainWindow

    settings = Settings.instance

    @settings_gui = SettingsGUI.new(settings.window_width,
                                    settings.window_height,
                                    stateful.main_window)
    @settings_gui.show
    @controller = SettingsController.new(self, @settings_gui)

    # assert settings_gui.is_a? SettingsGUI
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
