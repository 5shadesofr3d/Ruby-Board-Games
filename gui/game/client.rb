require 'Qt'
require 'test/unit'
require 'xmlrpc/server'
require_relative 'model'
require_relative '../player'
require_relative '../debug'

module Game
	class Client < Qt::Object
		include Test::Unit::Assertions
		include Debug
		attr_reader :address, :port, :server
		attr_reader :user
		attr_reader :model, :lobby, :board

		def initialize(username: "Godzilla", address: "local", port: 8080, parent: nil)
			parent != nil ? super(parent) : super()
			@user = Player::Online.new(username, Qt::green, parent: self)
			@address = address
			@port = port

			setupServerConnection()
			setupProxy()
			setupUI()
		end

		def setupServerConnection()
			@server = XMLRPC::Client.new(port)
		end

		def setupProxy()
			@model = @server.proxy("#{address}_model")
			@lobby = @server.proxy("#{address}_lobby")
			@board = @server.proxy("#{address}_board")
		end

		def setupUI()
			@view = Game::View.new(model.rows, model.columns, parent: self)
			model.addView @view
			model.start()

			lobby.add(@user)
			lobby.notify()
		end
	end
end