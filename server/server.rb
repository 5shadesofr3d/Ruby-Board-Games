# require "xmlrpc/server"
#
# # create a server which ‘listens’ at the standard HTTP secondary port
# s = XMLRPC::Server.new(8080)
#
# # create handler and bind to proxy object
# s.add_handler("sample", MyHandler.new)
#
# #start service and wait for call ….
# s.serve

require "xmlrpc/server"

class MyHandler
  attr_accessor :num_players, :lobby, :num_ready

  def initialize
    @num_players = 0
    @num_ready = 0
    @lobby = []
  end


  def lobby_connect(user)
    @num_players += 1
    @lobby.push user
    "#{user} has logged in #{@num_players} times!"
  end

  def is_ready
    if @num_ready == 2
      return true
    end
    return false
  end

  def ready
    @num_ready += 1
  end

  def players
    @lobby.length
  end

end

server = XMLRPC::Server.new(1234)
server.add_handler("sample", MyHandler.new)
server.serve


# server_test = MyHandler.new
# server_test.lobby_connect("user2")