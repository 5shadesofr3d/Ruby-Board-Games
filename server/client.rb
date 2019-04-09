require 'singleton'

class Client
  include Singleton
  attr_accessor :conn, :username, :player_number

  def initialize
    @username = ""
    @player_number = 0
    @conn = XMLRPC::Client.new( "localhost", "/", 1235 )
  end

end
