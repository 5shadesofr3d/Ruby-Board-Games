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

    setup_ui

  end

  def set_background(c = Qt::white)
    puts c.is_a? Qt::Color
    assert c.is_a? Qt::Color or c.is_a? Qt::Enum
    palette = Qt::Palette.new(c)
    setAutoFillBackground(true)
    setPalette(palette)
    assert palette.is_a? Qt::Palette
  end

  # --- Auto-generated section ---
  def setupUi()
    # assert settingsWindow.is_a? Qt::MainWindow
    assert Settings.instance.valid?

    theme = Settings.instance.theme

    # if settingsWindow.objectName.nil?
    #   settingsWindow.objectName = "settingsWindow"
    # end
    #
    # settingsWindow.resize(854, 611)
    # settingsWindow.styleSheet = ""

    puts theme
    # Change the background.
    set_background(theme.color[:background])

    # @centralWidget = Qt::Widget.new(settingsWindow)
    # @centralWidget.objectName = "centralWidget"
    # @verticalLayoutWidget = Qt::Widget.new(@centralWidget)

    @verticalLayoutWidget = Qt::Widget.new(self)
    @verticalLayoutWidget.objectName = "verticalLayoutWidget"
    @verticalLayoutWidget.geometry = Qt::Rect.new(40, 9, 761, 541)

    @verticalLayout = Qt::VBoxLayout.new(@verticalLayoutWidget)
    @verticalLayout.spacing = 6
    @verticalLayout.margin = 11
    @verticalLayout.objectName = "verticalLayout"
    @verticalLayout.setContentsMargins(0, 0, 0, 0)
    @gameSettingsText = Qt::Label.new(@verticalLayoutWidget)
    @gameSettingsText.objectName = "gameSettingsText"
    @gameSettingsText.maximumSize = Qt::Size.new(16777215, 75)
    @font = Qt::Font.new
    @font.family = "Serif"
    @font.pointSize = 20
    @font.bold = true
    @font.weight = 75
    @gameSettingsText.font = @font

    @verticalLayout.addWidget(@gameSettingsText)

    @gameGridLayout = Qt::GridLayout.new()
    @gameGridLayout.spacing = 6
    @gameGridLayout.objectName = "gameGridLayout"
    @gameModeComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @gameModeComboBox.objectName = "gameModeComboBox"
    @font1 = Qt::Font.new
    @font1.family = "Sans Serif"
    @font1.pointSize = 16
    @gameModeComboBox.font = @font1
    @gameModeComboBox.autoFillBackground = false

    @gameGridLayout.addWidget(@gameModeComboBox, 1, 1, 1, 1)

    @gameModeText = Qt::Label.new(@verticalLayoutWidget)
    @gameModeText.objectName = "gameModeText"
    @gameModeText.minimumSize = Qt::Size.new(0, 50)
    @gameModeText.maximumSize = Qt::Size.new(16777215, 35)
    @gameModeText.font = @font1

    @gameGridLayout.addWidget(@gameModeText, 1, 0, 1, 1)

    @boardSizeText = Qt::Label.new(@verticalLayoutWidget)
    @boardSizeText.objectName = "boardSizeText"
    @boardSizeText.minimumSize = Qt::Size.new(0, 50)
    @boardSizeText.maximumSize = Qt::Size.new(16777215, 35)
    @boardSizeText.font = @font1

    @gameGridLayout.addWidget(@boardSizeText, 2, 0, 1, 1)

    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.spacing = 6
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @rowText = Qt::Label.new(@verticalLayoutWidget)
    @rowText.objectName = "rowText"
    @rowText.minimumSize = Qt::Size.new(20, 0)
    @rowText.maximumSize = Qt::Size.new(60, 16777215)
    @rowText.font = @font1

    @horizontalLayout_2.addWidget(@rowText)

    @rowSpinBox = Qt::SpinBox.new(@verticalLayoutWidget)
    @rowSpinBox.objectName = "rowSpinBox"
    @rowSpinBox.font = @font1
    @rowSpinBox.minimum = 1
    @rowSpinBox.value = 7

    @horizontalLayout_2.addWidget(@rowSpinBox)

    @columnText = Qt::Label.new(@verticalLayoutWidget)
    @columnText.objectName = "columnText"
    @columnText.font = @font1

    @horizontalLayout_2.addWidget(@columnText)

    @colSpinBox = Qt::SpinBox.new(@verticalLayoutWidget)
    @colSpinBox.objectName = "colSpinBox"
    @colSpinBox.font = @font1
    @colSpinBox.minimum = 1
    @colSpinBox.value = 6

    @horizontalLayout_2.addWidget(@colSpinBox)


    @gameGridLayout.addLayout(@horizontalLayout_2, 2, 1, 1, 1)


    @verticalLayout.addLayout(@gameGridLayout)

    @windowSettingsText = Qt::Label.new(@verticalLayoutWidget)
    @windowSettingsText.objectName = "windowSettingsText"
    @windowSettingsText.maximumSize = Qt::Size.new(16777215, 75)
    @windowSettingsText.font = @font

    @verticalLayout.addWidget(@windowSettingsText)

    @windowGridLayout = Qt::GridLayout.new()
    @windowGridLayout.spacing = 6
    @windowGridLayout.objectName = "windowGridLayout"
    @screenResolutionText = Qt::Label.new(@verticalLayoutWidget)
    @screenResolutionText.objectName = "screenResolutionText"
    @screenResolutionText.minimumSize = Qt::Size.new(0, 50)
    @screenResolutionText.maximumSize = Qt::Size.new(16777215, 35)
    @screenResolutionText.font = @font1

    @windowGridLayout.addWidget(@screenResolutionText, 1, 0, 1, 1)

    @themeText = Qt::Label.new(@verticalLayoutWidget)
    @themeText.objectName = "themeText"
    @themeText.minimumSize = Qt::Size.new(0, 50)
    @themeText.maximumSize = Qt::Size.new(16777215, 35)
    @themeText.font = @font1

    @windowGridLayout.addWidget(@themeText, 2, 0, 1, 1)

    @themeComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @themeComboBox.objectName = "themeComboBox"
    @themeComboBox.font = @font1

    @windowGridLayout.addWidget(@themeComboBox, 2, 1, 1, 1)

    @resolutionComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @resolutionComboBox.objectName = "resolutionComboBox"
    @resolutionComboBox.font = @font1

    @windowGridLayout.addWidget(@resolutionComboBox, 1, 1, 1, 1)

    @windowModeText = Qt::Label.new(@verticalLayoutWidget)
    @windowModeText.objectName = "windowModeText"
    @windowModeText.minimumSize = Qt::Size.new(0, 50)
    @windowModeText.maximumSize = Qt::Size.new(16777215, 35)
    @windowModeText.font = @font1

    @windowGridLayout.addWidget(@windowModeText, 0, 0, 1, 1)

    @windowModeComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @windowModeComboBox.objectName = "windowModeComboBox"
    @windowModeComboBox.font = @font1

    @windowGridLayout.addWidget(@windowModeComboBox, 0, 1, 1, 1)


    @verticalLayout.addLayout(@windowGridLayout)

    @verticalSpacer = Qt::SpacerItem.new(20, 10, Qt::SizePolicy::Minimum, Qt::SizePolicy::Fixed)

    @verticalLayout.addItem(@verticalSpacer)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.spacing = 6
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @applyButton = Qt::PushButton.new(@verticalLayoutWidget)
    @applyButton.objectName = "applyButton"
    @applyButton.minimumSize = Qt::Size.new(200, 75)
    @applyButton.font = @font1

    @horizontalLayout.addWidget(@applyButton)

    @cancelButton = Qt::PushButton.new(@verticalLayoutWidget)
    @cancelButton.objectName = "cancelButton"
    @cancelButton.minimumSize = Qt::Size.new(175, 75)
    @cancelButton.font = @font1

    @horizontalLayout.addWidget(@cancelButton)


    @verticalLayout.addLayout(@horizontalLayout)

    # settingsWindow.centralWidget = @centralWidget
    # @menuBar = Qt::MenuBar.new(settingsWindow)
    # @menuBar.objectName = "menuBar"
    # @menuBar.geometry = Qt::Rect.new(0, 0, 854, 25)
    # settingsWindow.setMenuBar(@menuBar)
    # @mainToolBar = Qt::ToolBar.new(settingsWindow)
    # @mainToolBar.objectName = "mainToolBar"
    # settingsWindow.addToolBar(Qt::TopToolBarArea, @mainToolBar)
    # @statusBar = Qt::StatusBar.new(settingsWindow)
    # @statusBar.objectName = "statusBar"
    # settingsWindow.statusBar = @statusBar

    retranslateUi

    # Qt::MetaObject.connectSlotsByName(settingsWindow) # TODO: Might not need this.

    #assert @menuBar.is_a? Qt::MenuBar
    #assert @mainToolBar.is_a? Qt::ToolBar
    #assert @statusBar.is_a? Qt::StatusBar
    assert @cancelButton.is_a? Qt::PushButton
    assert @applyButton.is_a? Qt::PushButton
    assert @gameModeComboBox.is_a? Qt::ComboBox
    assert @themeComboBox.is_a? Qt::ComboBox
    assert @resolutionComboBox.is_a? Qt::ComboBox

  end # setupUi

  def setup_ui
    setupUi
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
                                   Qt::Application.translate("SettingsWindow", "Some colour blind ones...", nil, Qt::Application::UnicodeUTF8)])
    @resolutionComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "600x800", nil, Qt::Application::UnicodeUTF8)])
    @windowModeText.text = Qt::Application.translate("SettingsWindow", "Window Mode:", nil, Qt::Application::UnicodeUTF8)
    @windowModeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Windowed", nil, Qt::Application::UnicodeUTF8),
                                        Qt::Application.translate("SettingsWindow", "Fullscreen", nil, Qt::Application::UnicodeUTF8)])
    @applyButton.text = Qt::Application.translate("SettingsWindow", "Apply Changes", nil, Qt::Application::UnicodeUTF8)
    @cancelButton.text = Qt::Application.translate("SettingsWindow", "Cancel", nil, Qt::Application::UnicodeUTF8)
  end # retranslateUi

  # def retranslate_ui(settingsWindow)
  #   retranslateUi(settingsWindow)
  # end

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
