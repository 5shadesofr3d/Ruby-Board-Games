require 'test/unit'
require 'xmlrpc/server'
require_relative 'model'
require_relative '../debug'

module Game
	class Server
		include Test::Unit::Assertions
		include Debug
		attr_reader :address, :port, :server
		attr_reader :model

		def initialize(address: "local", port: 8080, model: nil)
			assert model.is_a?(Game::Model::Abstract)
			@model = model
			@address = address
			@port = port
			@server = XMLRPC::Server.new(port)			
			@server.add_handler("#{address}_model", model)
			@server.add_handler("#{address}_lobby", model.lobby)
		end

		def serve()
			@thread = Thread.new { @server.serve }
		end
	end
end