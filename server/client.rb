require 'singleton'

class Client
  include Singleton
  attr_accessor :conn, :username

  def initialize
    @username = ""
    @conn = XMLRPC::Client.new( "localhost", "/", 1234 )
  end

end