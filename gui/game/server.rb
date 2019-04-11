require 'test/unit'
require 'xmlrpc/server'
require_relative 'model'
require_relative '../debug'

module Game
	class Server
		include Test::Unit::Assertions
		include Debug
		attr_reader :address, :port, :connection
		attr_reader :game

		@@MAX_CONNECTIONS = 10

		def initialize(address: "hello", port: 8080, model: nil)
			assert model.is_a?(Game::Model::Abstract)
			@game = model
			@address = address
			@port = port
			@connection = XMLRPC::Server.new(port, "localhost", @@MAX_CONNECTIONS)
			setupHandlers()
		end

		def setupHandlers
			@connection.add_handler("#{address}_game", GameHandler.new(game))
			@connection.add_handler("#{address}_lobby", LobbyHandler.new(game.lobby))
			@connection.add_handler("#{address}_board", game.board)
		end

		def serve()
			@thread = Thread.new { @connection.serve }
			game.start()
		end
	end

	class LobbyHandler
		def initialize(lobby)
			@lobby = lobby
		end

		def add(data)
			Qt.execute_in_main_thread do
				obj = Player::Abstract::from_json(data)
				@lobby.add(obj)
			end
			return true
		end

		def remove(data)
			Qt.execute_in_main_thread do
				obj = Player::Abstract::from_json(data)
				@lobby.remove(obj)
			end
			return true
		end
	end

	class GameHandler
		def initialize(game)
			@game = game
		end

		def instance()
			data = nil
			Qt.execute_in_main_thread do
				data = JSON.dump(@game)
			end
			return data
		end

		def rows()
			return @game.rows
		end

		def columns()
			return @game.columns
		end
	end

	# class Model::Proxy
	# 	attr_reader :model, :server

	# 	def initialize(model, port)
	# 		@model = model
	# 	end

	# 	def addView(proxy_view)
	# 		proxy_view.setup(@server)
	# 	end

	# 	def notify()

	# 	end

	# end
end