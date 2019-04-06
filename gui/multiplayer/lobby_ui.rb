=begin
** Form generated from reading ui file 'lobby.ui'
**
** Created: Fri Apr 5 19:03:24 2019
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

class LobbyGUI < Qt::Widget

    attr_reader :centralWidget
    attr_reader :verticalLayoutWidget
    attr_reader :verticalLayout
    attr_reader :horizontalLayout
    attr_reader :usernameLabel
    attr_reader :usernameText
    attr_reader :quickMatchButton
    attr_reader :menuBar
    attr_reader :mainToolBar
    attr_reader :statusBar

    def initialize(parent = nil)
        parent != nil ? super(parent) : super()

        @verticalLayout = Qt::VBoxLayout.new(self)
        @verticalLayout.spacing = 6
        @verticalLayout.margin = 11
        @verticalLayout.objectName = "verticalLayout"
        @verticalLayout.setContentsMargins(0, 0, 0, 0)

        setLayout(@verticalLayout)
        setupUi

    end

    def setupUi()

        @horizontalLayout = Qt::HBoxLayout.new()
        @horizontalLayout.spacing = 6
        @horizontalLayout.objectName = "horizontalLayout"

        @usernameLabel = Qt::Label.new
        @usernameLabel.objectName = "usernameLabel"
        @horizontalLayout.addWidget(@usernameLabel)

        @usernameText = Qt::TextEdit.new
        @usernameText.objectName = "usernameText"
        @horizontalLayout.addWidget(@usernameText)

        @verticalLayout.addLayout(@horizontalLayout)

        @quickMatchButton = Qt::PushButton.new
        @quickMatchButton.objectName = "quickMatchButton"
        @verticalLayout.addWidget(@quickMatchButton)


        retranslateUi


    end # setupUi


    def retranslateUi
        @usernameLabel.text = Qt::Application.translate("MainWindow", "Username:", nil, Qt::Application::UnicodeUTF8)
        @quickMatchButton.text = Qt::Application.translate("MainWindow", "Quick Match", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi


end

