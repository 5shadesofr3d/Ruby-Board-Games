require 'Qt'

class Theme
  attr_accessor :name, :color

  def initialize(name)

    @name = name
    @color = {:text => Qt::Color.fromRgb(0, 0, 0),
              :background => Qt::Color.fromRgb(255, 255, 0)}

  end

  def load_theme(filename)

  end

end