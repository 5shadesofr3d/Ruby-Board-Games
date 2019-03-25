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
    elsif name == :Colorblind
      @color = {:text => "rgb(255, 255, 255)",
                :background => "rgb(0, 109, 219)",
                :board_background => "rgb(182, 109, 255)",
                :button => "rgb(0, 146, 146)",
                :tile_color => "rgb(73, 0, 146)"}
    end


  end

end