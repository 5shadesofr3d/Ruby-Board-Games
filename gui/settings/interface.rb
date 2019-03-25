require 'Qt4'
require 'test/unit'
require_relative '../settings'

class SettingsGUI < Qt::Widget
  include Test::Unit::Assertions

  attr_reader :gameModeComboBox
  attr_reader :themeComboBox
  attr_reader :resolutionComboBox
  attr_reader :windowModeComboBox
  attr_reader :rowSpinBox
  attr_reader :colSpinBox
  attr_reader :applyButton
  attr_reader :cancelButton

  def initialize(width = 800, height = 600, parent = nil)
    assert width.is_a? Integer
    assert height.is_a? Integer
    assert width > 0
    assert height > 0
    parent != nil ? super(parent) : super()

    @verticalLayout = Qt::VBoxLayout.new(self)
    @verticalLayout.spacing = 6
    @verticalLayout.margin = 11
    @verticalLayout.objectName = "verticalLayout"
    @verticalLayout.setContentsMargins(50, 50, 50, 50)

    setLayout(@verticalLayout)
    resize(width, height)
    setWindowTitle("Settings")

    setup_ui

  end

  def setupUi()
    # assert settingsWindow.is_a? Qt::MainWindow
    assert Settings.instance.valid?

    theme = Settings.instance.theme

    # Set the background of the window.
    setStyleSheet("background-color: #{theme.color[:background]};")

    button_style = "background-color: #{theme.color[:button]}; " +
                   "color: #{theme.color[:text]}; " +
                   "border-radius: 5px"

    spin_style = "color: #{theme.color[:text]}; " +
                   "border-radius: 5px"

    text_style = "color: #{theme.color[:text]}; "

    combo_style = "QComboBox { border: 1px solid gray;
                               border-radius: 5px;
                               padding: 1px 18px 1px 3px;
                               min-width: 6em; }
                   QComboBox:editable { background-color: #{theme.color[:button]};" +
                                       "color: #{theme.color[:text]}; }"

    @font = Qt::Font.new
    @font.family = "Serif"
    @font.pointSize = 20
    @font.bold = true
    @font.weight = 75

    @font1 = Qt::Font.new
    @font1.family = "Sans Serif"
    @font1.pointSize = 16

    @gameSettingsText = Qt::Label.new
    @gameSettingsText.objectName = "gameSettingsText"
    @gameSettingsText.maximumSize = Qt::Size.new(16777215, 75)
    @gameSettingsText.font = @font
    @gameSettingsText.setStyleSheet(text_style)

    @verticalLayout.addWidget(@gameSettingsText)

    @gameGridLayout = Qt::GridLayout.new()
    @gameGridLayout.spacing = 6
    @gameGridLayout.objectName = "gameGridLayout"
    @gameModeComboBox = Qt::ComboBox.new
    @gameModeComboBox.objectName = "gameModeComboBox"

    @gameModeComboBox.font = @font1
    @gameModeComboBox.autoFillBackground = false
    @gameModeComboBox.setStyleSheet(combo_style)

    @gameGridLayout.addWidget(@gameModeComboBox, 1, 1, 1, 1)

    @gameModeText = Qt::Label.new
    @gameModeText.objectName = "gameModeText"
    @gameModeText.minimumSize = Qt::Size.new(0, 50)
    @gameModeText.maximumSize = Qt::Size.new(16777215, 35)
    @gameModeText.font = @font1
    @gameModeText.setStyleSheet(text_style)

    @gameGridLayout.addWidget(@gameModeText, 1, 0, 1, 1)

    @boardSizeText = Qt::Label.new
    @boardSizeText.objectName = "boardSizeText"
    @boardSizeText.minimumSize = Qt::Size.new(0, 50)
    @boardSizeText.maximumSize = Qt::Size.new(16777215, 35)
    @boardSizeText.font = @font1
    @boardSizeText.setStyleSheet(text_style)

    @gameGridLayout.addWidget(@boardSizeText, 2, 0, 1, 1)

    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.spacing = 6
    @horizontalLayout_2.objectName = "horizontalLayout_2"

    @rowText = Qt::Label.new
    @rowText.objectName = "rowText"
    @rowText.minimumSize = Qt::Size.new(20, 0)
    @rowText.maximumSize = Qt::Size.new(60, 16777215)
    @rowText.font = @font1
    @rowText.setStyleSheet(text_style)

    @horizontalLayout_2.addWidget(@rowText)

    @rowSpinBox = Qt::SpinBox.new
    @rowSpinBox.objectName = "rowSpinBox"
    @rowSpinBox.font = @font1
    @rowSpinBox.minimum = 1
    @rowSpinBox.value = 7
    @rowSpinBox.setStyleSheet(spin_style)

    @horizontalLayout_2.addWidget(@rowSpinBox)

    @columnText = Qt::Label.new
    @columnText.objectName = "columnText"
    @columnText.font = @font1
    @columnText.setStyleSheet(text_style)

    @horizontalLayout_2.addWidget(@columnText)

    @colSpinBox = Qt::SpinBox.new
    @colSpinBox.objectName = "colSpinBox"
    @colSpinBox.font = @font1
    @colSpinBox.minimum = 1
    @colSpinBox.value = 6
    @colSpinBox.setStyleSheet(spin_style)

    @horizontalLayout_2.addWidget(@colSpinBox)


    @gameGridLayout.addLayout(@horizontalLayout_2, 2, 1, 1, 1)


    @verticalLayout.addLayout(@gameGridLayout)

    @windowSettingsText = Qt::Label.new
    @windowSettingsText.objectName = "windowSettingsText"
    @windowSettingsText.maximumSize = Qt::Size.new(16777215, 75)
    @windowSettingsText.font = @font
    @windowSettingsText.setStyleSheet(text_style)

    @verticalLayout.addWidget(@windowSettingsText)

    @windowGridLayout = Qt::GridLayout.new()
    @windowGridLayout.spacing = 6
    @windowGridLayout.objectName = "windowGridLayout"

    @screenResolutionText = Qt::Label.new
    @screenResolutionText.objectName = "screenResolutionText"
    @screenResolutionText.minimumSize = Qt::Size.new(0, 50)
    @screenResolutionText.maximumSize = Qt::Size.new(16777215, 35)
    @screenResolutionText.font = @font1
    @screenResolutionText.setStyleSheet(text_style)

    @windowGridLayout.addWidget(@screenResolutionText, 1, 0, 1, 1)

    @themeText = Qt::Label.new
    @themeText.objectName = "themeText"
    @themeText.minimumSize = Qt::Size.new(0, 50)
    @themeText.maximumSize = Qt::Size.new(16777215, 35)
    @themeText.font = @font1
    @themeText.setStyleSheet(text_style)

    @windowGridLayout.addWidget(@themeText, 2, 0, 1, 1)

    @themeComboBox = Qt::ComboBox.new
    @themeComboBox.objectName = "themeComboBox"
    @themeComboBox.font = @font1
    @themeComboBox.setStyleSheet(combo_style)

    @windowGridLayout.addWidget(@themeComboBox, 2, 1, 1, 1)

    @resolutionComboBox = Qt::ComboBox.new
    @resolutionComboBox.objectName = "resolutionComboBox"
    @resolutionComboBox.font = @font1
    @resolutionComboBox.setStyleSheet(combo_style)

    @windowGridLayout.addWidget(@resolutionComboBox, 1, 1, 1, 1)

    @windowModeText = Qt::Label.new
    @windowModeText.objectName = "windowModeText"
    @windowModeText.minimumSize = Qt::Size.new(0, 50)
    @windowModeText.maximumSize = Qt::Size.new(16777215, 35)
    @windowModeText.font = @font1
    @windowModeText.setStyleSheet(text_style)

    @windowGridLayout.addWidget(@windowModeText, 0, 0, 1, 1)

    @windowModeComboBox = Qt::ComboBox.new
    @windowModeComboBox.objectName = "windowModeComboBox"
    @windowModeComboBox.font = @font1
    @windowModeComboBox.setStyleSheet(combo_style)

    @windowGridLayout.addWidget(@windowModeComboBox, 0, 1, 1, 1)


    @verticalLayout.addLayout(@windowGridLayout)

    @verticalSpacer = Qt::SpacerItem.new(20, 10, Qt::SizePolicy::Minimum, Qt::SizePolicy::Fixed)

    @verticalLayout.addItem(@verticalSpacer)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.spacing = 6
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @applyButton = Qt::PushButton.new
    @applyButton.objectName = "applyButton"
    @applyButton.minimumSize = Qt::Size.new(200, 75)
    @applyButton.font = @font1
    @applyButton.setStyleSheet(button_style)

    @horizontalLayout.addWidget(@applyButton)

    @cancelButton = Qt::PushButton.new
    @cancelButton.objectName = "cancelButton"
    @cancelButton.minimumSize = Qt::Size.new(175, 75)
    @cancelButton.font = @font1
    @cancelButton.setStyleSheet(button_style)

    @horizontalLayout.addWidget(@cancelButton)


    @verticalLayout.addLayout(@horizontalLayout)


    retranslateUi
    initialize_ui

    assert @cancelButton.is_a? Qt::PushButton
    assert @applyButton.is_a? Qt::PushButton
    assert @gameModeComboBox.is_a? Qt::ComboBox
    assert @themeComboBox.is_a? Qt::ComboBox
    assert @resolutionComboBox.is_a? Qt::ComboBox

  end # setupUi

  def setup_ui
    setupUi
  end

  def valid_settings?
    return false if Settings.instance.valid_game_mode.index(Settings.instance.game_mode).nil?
    return false if Settings.instance.valid_themes.index(Settings.instance.theme_setting).nil?
    return false if Settings.instance.valid_window_mode.index(Settings.instance.window_mode).nil?
    resolution = "#{Settings.instance.window_width}x#{Settings.instance.window_height}"
    return false if Settings.instance.valid_resolutions.index(resolution).nil?
    return true
  end

  def initialize_ui
    assert Settings.instance.valid?
    assert valid_settings?

    settings = Settings.instance

    @rowSpinBox.value = settings.num_rows
    @colSpinBox.value = settings.num_cols

    @gameModeComboBox.currentIndex = settings.valid_game_mode
                                             .index(settings.game_mode)
    @themeComboBox.currentIndex = settings.valid_themes
                                          .index(settings.theme_setting)
    @windowModeComboBox.currentIndex = settings.valid_window_mode
                                               .index(settings.window_mode)

    resolution = "#{settings.window_width}x#{settings.window_height}"
    @resolutionComboBox.currentIndex = settings.valid_resolutions
                                               .index(resolution)



  end

  def retranslateUi
    # assert settingsWindow.is_a? Qt::MainWindow

    windowTitle = Qt::Application.translate("SettingsWindow", "Settings", nil, Qt::Application::UnicodeUTF8)
    @gameSettingsText.text = Qt::Application.translate("SettingsWindow", "Game Settings", nil, Qt::Application::UnicodeUTF8)
    @gameModeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Connect 4", nil, Qt::Application::UnicodeUTF8),
                                      Qt::Application.translate("SettingsWindow", "OTTO/TOOT", nil, Qt::Application::UnicodeUTF8)])
    @gameModeText.text = Qt::Application.translate("SettingsWindow", "Game Mode:", nil, Qt::Application::UnicodeUTF8)
    @boardSizeText.text = Qt::Application.translate("SettingsWindow", "Board Size:", nil, Qt::Application::UnicodeUTF8)
    @rowText.text = Qt::Application.translate("SettingsWindow", "Rows:", nil, Qt::Application::UnicodeUTF8)
    @columnText.text = Qt::Application.translate("SettingsWindow", "Columns:", nil, Qt::Application::UnicodeUTF8)
    @windowSettingsText.text = Qt::Application.translate("SettingsWindow", "Window Settings", nil, Qt::Application::UnicodeUTF8)
    @screenResolutionText.text = Qt::Application.translate("SettingsWindow", "Resolution:", nil, Qt::Application::UnicodeUTF8)
    @themeText.text = Qt::Application.translate("SettingsWindow", "Theme:", nil, Qt::Application::UnicodeUTF8)
    @themeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Default", nil, Qt::Application::UnicodeUTF8),
                                   Qt::Application.translate("SettingsWindow", "Colorblind", nil, Qt::Application::UnicodeUTF8)])
    @resolutionComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "800x700", nil, Qt::Application::UnicodeUTF8)])
    @windowModeText.text = Qt::Application.translate("SettingsWindow", "Window Mode:", nil, Qt::Application::UnicodeUTF8)
    @windowModeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Windowed", nil, Qt::Application::UnicodeUTF8),
                                        Qt::Application.translate("SettingsWindow", "Fullscreen", nil, Qt::Application::UnicodeUTF8)])
    @applyButton.text = Qt::Application.translate("SettingsWindow", "Apply Changes", nil, Qt::Application::UnicodeUTF8)
    @cancelButton.text = Qt::Application.translate("SettingsWindow", "Cancel", nil, Qt::Application::UnicodeUTF8)
  end # retranslateUi

  # When apply button is clicked, run call back.
  # create a settingsGUI instance and change the variables.
  # In the application states, confirm the settings changed.
  #
  # When we press cancel, how will we know whether we gone
  # back to the settings?  The main issue is when a state
  # gets executed, the UI changes but it doesn't get stuck
  # anywhere. Is it possible to have a call back in the
  # parent? Or do we need to move the class to a state?

end
