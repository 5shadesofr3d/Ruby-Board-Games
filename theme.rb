require 'Qt'

class Theme
  attr_accessor :name, :color

  def initialize(name)

    @name = name
    @color = {:text => "rgb(255, 255, 255)",
              :background => "rgb(0, 128, 128)",
              :button => "rgb(66, 134, 244)"}

  end

  def load_theme(filename)

  end

end