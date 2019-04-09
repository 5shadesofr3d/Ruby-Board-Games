require 'Qt'
require 'test/unit'

class Title < Qt::Widget
  include Test::Unit::Assertions

  attr_reader :bPlay
  attr_reader :bMultiplayer
  attr_reader :bSettings
  attr_reader :bQuit

  def initialize(width = 800, height = 600, parent = nil)
    assert width.is_a? Integer
    assert height.is_a? Integer
    assert width > 0
    assert height > 0
    parent != nil ? super(parent) : super()

    @parent = parent
    @layout = Qt::VBoxLayout.new(self)
    @layout.setSpacing(height/6) #This value seems to use the screen spae well
    setLayout(@layout)
    setScreenSize(width,height)
    setWindowTitle("Ruby-Board-Games")
    show
    drawMenu
    draw_color

    # @parent.showFullScreen
    assert @layout.is_a? Qt::VBoxLayout
  end

  # Sets the size of the main window and the title screen
  def setScreenSize(width, height)
    assert width.is_a?(Integer) and width.between?(100, 1920)
		assert height.is_a?(Integer) and height.between?(100, 1080)

		resize(width, height)
    @parent.setFixedSize(width, height)

		assert width() == width
		assert height() == height
  end

  def draw_color

    theme = Settings.instance.theme

    # Set the background of the window.
    setStyleSheet("background-color: #{theme.color[:background]};")

    button_style = "background-color: #{theme.color[:button]};
                    color: #{theme.color[:text]};
                    border-radius: 5px;"

    text_style = "color: #{theme.color[:text]}; "

    @title.setStyleSheet(text_style)

    @bPlay.setStyleSheet(button_style)
    @bMultiplayer.setStyleSheet(button_style)
    @bSettings.setStyleSheet(button_style)
    @bQuit.setStyleSheet(button_style)

    # self.repaint

  end

  def drawMenu
    assert valid?
    assert Settings.instance.valid?


    fontT = Qt::Font.new
    fontT.family = "Sans Serif"
    fontT.pointSize = 36
    fontB = Qt::Font.new
    fontB.family = "Sans Serif"
    fontB.pointSize = 24

    @title = Qt::Label.new
    @title.maximumSize = Qt::Size.new(16777215, 46)
    @title.font = fontT
    @title.text = "Connect N"

    @bPlay = Qt::PushButton.new("Play")
    @bPlay.font = fontB
    @bPlay.setAutoFillBackground(true)
    @bPlay.maximumSize = Qt::Size.new(300, 50)

    @bMultiplayer = Qt::PushButton.new("Multiplayer")
    @bMultiplayer.font = fontB
    @bMultiplayer.setAutoFillBackground(true)
    @bMultiplayer.maximumSize = Qt::Size.new(300, 50)

    @bSettings = Qt::PushButton.new("Settings")
    @bSettings.font = fontB
    @bSettings.setAutoFillBackground(true)
    @bSettings.maximumSize = Qt::Size.new(300, 50)

    @bQuit = Qt::PushButton.new("Exit")
    @bQuit.font = fontB
    @bQuit.setAutoFillBackground(true)
    @bQuit.maximumSize = Qt::Size.new(300, 50)

    @layout.setAlignment(Qt::AlignTop | Qt::AlignHCenter)

    @layout.addWidget(@title)
    @layout.addWidget(@bPlay)
    @layout.addWidget(@bMultiplayer)
    @layout.addWidget(@bSettings)
    @layout.addWidget(@bQuit)

    assert @bPlay.is_a? Qt::PushButton
    assert @bMultiplayer.is_a? Qt::PushButton
    assert @bSettings.is_a? Qt::PushButton
    assert @bQuit.is_a? Qt::PushButton
    assert valid?
  end

  def valid?
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::VBoxLayout
    return true
  end


end
