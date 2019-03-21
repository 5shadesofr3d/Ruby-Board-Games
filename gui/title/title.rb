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

    @layout = Qt::GridLayout.new(self)
		@layout.setSpacing(10)
    setLayout(@layout)
    setScreenSize(width,height)
    setWindowTitle("Ruby-Board-Games")
    move(100, 100)
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

    assert valid?
  end

  def valid?
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::GridLayout
    return true
  end


end

app = Qt::Application.new ARGV
t = Title.new
app.exec
