require 'test/unit'
require 'xmlrpc/server'
require_relative 'model'
require_relative '../debug'

module Game
	class Server
		include Test::Unit::Assertions
		include Debug
		attr_reader :address, :port, :connection
		attr_reader :model

		@@MAX_CONNECTIONS = 10

		def initialize(address: "hello", port: 8080, model: nil)
			assert model.is_a?(Game::Model::Abstract)
			@model = model
			@address = address
			@port = port
			@connection = XMLRPC::Server.new(port, "localhost", @@MAX_CONNECTIONS)
			setupHandlers()
		end

		def setupHandlers
			@connection.add_handler("#{address}_model", GameHandler.new(model))
			@connection.add_handler("#{address}_lobby", LobbyHandler.new(model.lobby))
			@connection.add_handler("#{address}_board", model.board)
		end

		def serve()
			@thread = Thread.new { @connection.serve }
		end
	end

	class LobbyHandler
		def initialize(lobby)
			@lobby = lobby
		end

		def host()
			data = nil
			Qt.execute_in_main_thread do
				data = @lobby.players.first.name
			end
			return data
		end

		def update(player)
			Qt.execute_in_main_thread do
				obj = Player::Abstract::from_json(player)
				@lobby.update(obj)
			end
			return true
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

		def pregameSetup()
			Qt.execute_in_main_thread do
				@game.initializePlayerGoals()
			end
			return true
		end

		def update(model)
			Qt.execute_in_main_thread do
				model = Game::Model::Abstract::from_json(model)
				@game.board = model.board
				@game.lobby = model.lobby
			end
			return true
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