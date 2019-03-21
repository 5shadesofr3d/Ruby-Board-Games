require 'Qt'
require 'test/unit'

class Title < Qt::Widget
  include Test::Unit::Assertions

  def initialize(width = 800, height = 600)
    assert width.is_a? Numeric
    assert height.is_a? Numeric
    assert width > 0
    assert height > 0

    @layout = Qt::GridLayout.new(self)
		@layout.setSpacing(10)
    setLayout(@layout)

    setScreenSize(width,height)

    drawMenu()
  end

  def setScreenSize(width, height)
    assert width.is_a?(Integer) and width.between?(100, 1920)
		assert height.is_a?(Integer) and height.between?(100, 1080)

		resize(width, height)

		assert width() == width
		assert height() == height
  end

  def drawMenu
    assert valid?
  end

  def valid?
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::GridLayout
  end


end
