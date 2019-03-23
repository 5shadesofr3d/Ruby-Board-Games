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

end

#TODO: Get rid of this
class TitleController < Qt::Widget
  include Test::Unit::Assertions

  slots 'play_game()','open_settings()','quit_game()'

  def initialize(state,window)
    assert state.is_a? TitleScreenState
    super()

    @state = state
    @window = window

    @title = Title.new(800,600,window)

    connect(@title.bPlay,  SIGNAL('clicked()'), self, SLOT('play_game()'))
    connect(@title.bSettings,  SIGNAL('clicked()'), self, SLOT('open_settings()'))
    connect(@title.bQuit,  SIGNAL('clicked()'), $qApp, SLOT('quit()'))

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
    puts stateful.main_window.is_a? Qt::Widget

    game = nil
    case Settings.instance.game_mode
    when :Connect4
      game = Connect4.new(parent: stateful.main_window)
    when :TOOT

    end

    assert game.is_a?(Game)

    game.start
    game.show

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

# sup = GameApplication.new

# a = QTApplication.instance
# hello = Qt::PushButton.new('Hello World!', nil)
# hello.resize(100, 30)
# hello.show()
# a.app.exec()
