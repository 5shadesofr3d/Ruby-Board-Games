require 'test/unit'
require_relative 'local'

module Player
	class Online < Abstract
	  attr_accessor :server  
	end
end