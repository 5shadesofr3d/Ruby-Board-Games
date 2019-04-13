require 'singleton'

class XMLClient
  include Singleton
  attr_accessor :server

  def initialize
    @server = nil
  end

  def connect(hostname, port)
    @server = XMLRPC::Client.new(hostname, "/RPC2", port)
  end

end