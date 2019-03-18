require 'singleton'
require 'Qt'

class QTApplication
  include Singleton
  attr_accessor :app

  def initialize
    @app = Qt::Application.new ARGV
  end

end