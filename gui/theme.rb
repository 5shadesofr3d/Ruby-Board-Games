require 'Qt'
require 'chroma'

class Theme
  attr_accessor :name, :color

  def initialize(name)

    @name = name

    if name == :Default
      @color = {:text => "rgb(255, 255, 255)",
                :background => "rgb(0, 128, 128)",
                :board_background => "rgb(240, 255, 255)",
                :button => "rgb(66, 134, 244)",
                :tile_color => "rgb(100, 134, 244)"}
    end


  end

end