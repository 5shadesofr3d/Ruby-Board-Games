require 'Qt'
require 'test/unit'
require 'xmlrpc/config'
require 'xmlrpc/server'
require_relative 'model'
require_relative 'view'
require_relative '../player'
require_relative '../debug'

module Game
	class Client < Qt::Object
		include Test::Unit::Assertions
		include Debug
		attr_reader :address, :port, :server, :connection
		attr_reader :game, :lobby, :board, :view

		def initialize(username: "Godzilla", address: "hello", port: 8080, parent: nil)
			parent != nil ? super(parent) : super()
			@user = Player::Online.new(username, "green")
			@address = address
			@port = port

			setupConnections()
			setupProxy()
			setupUI()
		end

		def setupConnections()
			@server = XMLRPC::Client.new("localhost", "/RPC2", port)
		end

		def setupProxy()
			@game = @server.proxy("#{address}_game")
			@lobby = @server.proxy("#{address}_lobby")
			@board = @server.proxy("#{address}_board")
		end

		def setupUI()
			# puts XMLRPC::Config::ENABLE_MARSHALLING
			@view = Game::View.new(game.rows, game.columns)
			@view.show()
			lobby.add(user)
			update()
		end

		def user()
			return JSON.dump(@user)
		end

		def update()
			@view.update(Game::Model::Abstract::from_json(game.instance))
		end

		def quit()
			lobby.remove(user)
		end
	end
end