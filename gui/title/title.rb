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
    font = Qt::Font.new
    font.family = "Sans Serif"
    font.pointSize = 24


    title = Qt::Label.new
    title.maximumSize = Qt::Size.new(16777215, 46)
    title.font = fontT
    title.text = "Connect N"

    b1 = Qt::PushButton.new("Play")
    b1.font = font
    b1.setAutoFillBackground(true)
    b1.setStyleSheet("background-color: rgb(66, 134, 244); color: rgb(255, 255, 255)")
    b1.maximumSize = Qt::Size.new(300, 50)
    b2 = Qt::PushButton.new("Settings")
    b2.font = font
    b2.setAutoFillBackground(true)
    b2.setStyleSheet("background-color: rgb(66, 134, 244); color: rgb(255, 255, 255)")
    b2.maximumSize = Qt::Size.new(300, 50)
    b3 = Qt::PushButton.new("Exit")
    b3.font = font
    b3.setAutoFillBackground(true)
    b3.setStyleSheet("background-color: rgb(66, 134, 244); color: rgb(255, 255, 255)")
    b3.maximumSize = Qt::Size.new(300, 50)


    @layout.setAlignment(Qt::AlignTop | Qt::AlignHCenter)
    
    @layout.addWidget(title)
    @layout.addWidget(b1)
    @layout.addWidget(b2)
    @layout.addWidget(b3)


    assert valid?
  end

  def valid?
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::VBoxLayout
    return true
  end


end

app = Qt::Application.new ARGV
t = Title.new
app.exec
