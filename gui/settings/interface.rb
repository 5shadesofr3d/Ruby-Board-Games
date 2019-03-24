require 'Qt4'
require 'test/unit'

class SettingsGUI
  include Test::Unit::Assertions

  attr_reader :gameModeComboBox
  # attr_reader :numberPlayersComboBox
  attr_reader :gameTypeComboBox
  attr_reader :themeComboBox
  attr_reader :resolutionComboBox
  attr_reader :applyButton
  attr_reader :cancelButton

  # --- Auto-generated section ---
  def setupUi(settingsWindow)
    assert settingsWindow.is_a? Qt::MainWindow

    if settingsWindow.objectName.nil?
      settingsWindow.objectName = "settingsWindow"
    end

    settingsWindow.resize(854, 611)
    settingsWindow.styleSheet = ""

    @centralWidget = Qt::Widget.new(settingsWindow)
    @centralWidget.objectName = "centralWidget"
    @verticalLayoutWidget = Qt::Widget.new(@centralWidget)
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
    # @numberOfPlayersText = Qt::Label.new(@verticalLayoutWidget)
    # @numberOfPlayersText.objectName = "numberOfPlayersText"
    # @numberOfPlayersText.maximumSize = Qt::Size.new(16777215, 35)
    @font1 = Qt::Font.new
    @font1.family = "Sans Serif"
    @font1.pointSize = 16
    # @numberOfPlayersText.font = @font1

    # @gameGridLayout.addWidget(@numberOfPlayersText, 3, 0, 1, 1)

    @gameModeComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @gameModeComboBox.objectName = "gameModeComboBox"
    @gameModeComboBox.font = @font1
    @gameModeComboBox.autoFillBackground = false

    @gameGridLayout.addWidget(@gameModeComboBox, 1, 1, 1, 1)

    @gameModeText = Qt::Label.new(@verticalLayoutWidget)
    @gameModeText.objectName = "gameModeText"
    @gameModeText.maximumSize = Qt::Size.new(16777215, 35)
    @gameModeText.font = @font1

    @gameGridLayout.addWidget(@gameModeText, 1, 0, 1, 1)

    # @numberPlayersComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    # @numberPlayersComboBox.objectName = "numberPlayersComboBox"
    # @numberPlayersComboBox.font = @font1
    #
    # @gameGridLayout.addWidget(@numberPlayersComboBox, 3, 1, 1, 1)

    @gameTypeText = Qt::Label.new(@verticalLayoutWidget)
    @gameTypeText.objectName = "gameTypeText"
    @gameTypeText.maximumSize = Qt::Size.new(16777215, 35)
    @gameTypeText.font = @font1

    @gameGridLayout.addWidget(@gameTypeText, 2, 0, 1, 1)

    @gameTypeComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @gameTypeComboBox.objectName = "gameTypeComboBox"
    @gameTypeComboBox.font = @font1

    @gameGridLayout.addWidget(@gameTypeComboBox, 2, 1, 1, 1)


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
    @screenResolutionText.maximumSize = Qt::Size.new(16777215, 35)
    @screenResolutionText.font = @font1

    @windowGridLayout.addWidget(@screenResolutionText, 0, 0, 1, 1)

    @themeText = Qt::Label.new(@verticalLayoutWidget)
    @themeText.objectName = "themeText"
    @themeText.maximumSize = Qt::Size.new(16777215, 35)
    @themeText.font = @font1

    @windowGridLayout.addWidget(@themeText, 1, 0, 1, 1)

    @themeComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @themeComboBox.objectName = "themeComboBox"
    @themeComboBox.font = @font1

    @windowGridLayout.addWidget(@themeComboBox, 1, 1, 1, 1)

    @resolutionComboBox = Qt::ComboBox.new(@verticalLayoutWidget)
    @resolutionComboBox.objectName = "resolutionComboBox"
    @resolutionComboBox.font = @font1

    @windowGridLayout.addWidget(@resolutionComboBox, 0, 1, 1, 1)

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

    settingsWindow.centralWidget = @centralWidget
    @menuBar = Qt::MenuBar.new(settingsWindow)
    @menuBar.objectName = "menuBar"
    @menuBar.geometry = Qt::Rect.new(0, 0, 854, 25)
    settingsWindow.setMenuBar(@menuBar)
    @mainToolBar = Qt::ToolBar.new(settingsWindow)
    @mainToolBar.objectName = "mainToolBar"
    settingsWindow.addToolBar(Qt::TopToolBarArea, @mainToolBar)
    @statusBar = Qt::StatusBar.new(settingsWindow)
    @statusBar.objectName = "statusBar"
    settingsWindow.statusBar = @statusBar

    retranslateUi(settingsWindow)

    Qt::MetaObject.connectSlotsByName(settingsWindow) # TODO: Might not need this.

    assert @menuBar.is_a? Qt::MenuBar
    assert @mainToolBar.is_a? Qt::ToolBar
    assert @statusBar.is_a? Qt::StatusBar
    assert @cancelButton.is_a? Qt::PushButton
    assert @applyButton.is_a? Qt::PushButton
    assert @gameModeComboBox.is_a? Qt::ComboBox
    assert @gameTypeComboBox.is_a? Qt::ComboBox
    assert @themeComboBox.is_a? Qt::ComboBox
    assert @resolutionComboBox.is_a? Qt::ComboBox
  end # setupUi

  def setup_ui(settingsWindow)
    setupUi(settingsWindow)
  end

  # TODO: Adds elements into the combo boxes, this can be cleaned up/
  def retranslateUi(settingsWindow)
    assert settingsWindow.is_a? Qt::MainWindow

    settingsWindow.windowTitle = Qt::Application.translate("SettingsWindow", "Settings", nil, Qt::Application::UnicodeUTF8)
    @gameSettingsText.text = Qt::Application.translate("SettingsWindow", "Game Settings", nil, Qt::Application::UnicodeUTF8)
    # @numberOfPlayersText.text = Qt::Application.translate("SettingsWindow", "Number of players:", nil, Qt::Application::UnicodeUTF8)
    @gameModeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Connect 4", nil, Qt::Application::UnicodeUTF8),
                                      Qt::Application.translate("SettingsWindow", "OTTO/TOOT", nil, Qt::Application::UnicodeUTF8)])
    @gameModeText.text = Qt::Application.translate("SettingsWindow", "Game Mode:", nil, Qt::Application::UnicodeUTF8)
    # @numberPlayersComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "2", nil, Qt::Application::UnicodeUTF8)])
    @gameTypeText.text = Qt::Application.translate("SettingsWindow", "Game Type:", nil, Qt::Application::UnicodeUTF8)
    @gameTypeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Single Player", nil, Qt::Application::UnicodeUTF8),
                                      Qt::Application.translate("SettingsWindow", "Multiplayer", nil, Qt::Application::UnicodeUTF8)])
    @windowSettingsText.text = Qt::Application.translate("SettingsWindow", "Window Settings", nil, Qt::Application::UnicodeUTF8)
    @screenResolutionText.text = Qt::Application.translate("SettingsWindow", "Window Size:", nil, Qt::Application::UnicodeUTF8)
    @themeText.text = Qt::Application.translate("SettingsWindow", "Theme:", nil, Qt::Application::UnicodeUTF8)
    @themeComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "Default", nil, Qt::Application::UnicodeUTF8),
                                   Qt::Application.translate("SettingsWindow", "Some colour blind ones...", nil, Qt::Application::UnicodeUTF8)])
    @resolutionComboBox.insertItems(0, [Qt::Application.translate("SettingsWindow", "400x600", nil, Qt::Application::UnicodeUTF8)])
    @applyButton.text = Qt::Application.translate("SettingsWindow", "Apply Changes", nil, Qt::Application::UnicodeUTF8)
    @cancelButton.text = Qt::Application.translate("SettingsWindow", "Cancel", nil, Qt::Application::UnicodeUTF8)
  end # retranslateUi

  def retranslate_ui(settingsWindow)
    retranslateUi(settingsWindow)
  end

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
