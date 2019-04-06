require 'singleton'

class Client
  include Singleton
  attr_accessor :conn

  def initialize
    @conn = XMLRPC::Client.new( "localhost", "/", 1234 )
  end

end