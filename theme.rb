require 'qt'

class Theme
  attr_accessor :name, :color

  def initialize(name)

    @name = name
    @color = {:text => 'black'.paint.to_hex,
              :background => Qt::Color.fromRgb(255, 255, 0)}

  end

  def load_theme(filename)

  end

end