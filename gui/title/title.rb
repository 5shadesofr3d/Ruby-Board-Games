require 'Qt'
require 'test/unit'

class Title < Qt::Widget
  include Test::Unit::Assertions

  def initialize(width = 800, height = 600)
    assert width.is_a? Numeric
    assert height.is_a? Numeric
    assert width > 0
    assert height > 0
    super()

    @layout = Qt::VBoxLayout.new(self)
		@layout.setSpacing(height/6) #This value seems to use the screen space well
    setLayout(@layout)
    setScreenSize(width,height)
    setWindowTitle("Ruby-Board-Games")
    setBackground(Qt::darkCyan)
    drawMenu()
    show()
  end

  def setScreenSize(width, height)
    assert width.is_a?(Integer) and width.between?(100, 1920)
		assert height.is_a?(Integer) and height.between?(100, 1080)

		resize(width, height)

		assert width() == width
		assert height() == height
  end

  def setBackground(c = Qt::white)
    assert c.is_a? Qt::Enum or c.is_a? Qt::Color
    palette = Qt::Palette.new(c)
		setAutoFillBackground(true)
		setPalette(palette)
    assert palette.is_a? Qt::Palette
  end

  def drawMenu
    assert valid?

    fontT = Qt::Font.new
    fontT.family = "Sans Serif"
    fontT.pointSize = 36
    fontB = Qt::Font.new
    fontB.family = "Sans Serif"
    fontB.pointSize = 24


    title = Qt::Label.new
    title.maximumSize = Qt::Size.new(16777215, 46)
    title.font = fontT
    title.text = "Connect N"

    @bPlay = Qt::PushButton.new("Play")
    @bPlay.font = fontB
    @bPlay.setAutoFillBackground(true)
    @bPlay.setStyleSheet("background-color: rgb(66, 134, 244); color: rgb(255, 255, 255)")
    @bPlay.maximumSize = Qt::Size.new(300, 50)
    @bSettings = Qt::PushButton.new("Settings")
    @bSettings.font = fontB
    @bSettings.setAutoFillBackground(true)
    @bSettings.setStyleSheet("background-color: rgb(66, 134, 244); color: rgb(255, 255, 255)")
    @bSettings.maximumSize = Qt::Size.new(300, 50)
    @bQuit = Qt::PushButton.new("Exit")
    @bQuit.font = fontB
    @bQuit.setAutoFillBackground(true)
    @bQuit.setStyleSheet("background-color: rgb(66, 134, 244); color: rgb(255, 255, 255)")
    @bQuit.maximumSize = Qt::Size.new(300, 50)


    @layout.setAlignment(Qt::AlignTop | Qt::AlignHCenter)

    @layout.addWidget(title)
    @layout.addWidget(@bPlay)
    @layout.addWidget(@bSettings)
    @layout.addWidget(@bQuit)


    assert valid?
  end

  def valid?
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::VBoxLayout
    return true
  end


end
