require 'singleton'
require_relative '../gui/settings'

class Client
  include Singleton
  attr_accessor :server

  def initialize
    settings = Settings.instance
    @server = XMLRPC::Client.new(settings.hostname,
                                 "/RPC2",
                                 settings.port_number)
  end

end