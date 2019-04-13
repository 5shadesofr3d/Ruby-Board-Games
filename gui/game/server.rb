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
		@@NUM_OF_SUBSERVERS = 5

		def initialize(address: "hello", port: 50525, model: nil)
			assert (model.is_a?(Game::Model::Abstract) or model.nil?)
			@model = model
			@address = address
			@port = port
			@connection = XMLRPC::Server.new(port, ENV['HOSTNAME'], @@MAX_CONNECTIONS)
			@subservers = []
			setupHandlers()
			setupSubservers()
		end

		def setupSubservers()
			(1..3).each do |i|
				PlayServer.new(address: "Lobby_#{i}", model: Game::Model::Connect4.new(), connection: @connection)
			end
			(1..2).each do |i|
				PlayServer.new(address: "Lobby_#{i}", model: Game::Model::OTTO.new(), connection: @connection)
			end
		end

		def setupHandlers()

		end

		def serve()
			@thread = Thread.new { @connection.serve }
		end
	end

	class PlayServer
		include Test::Unit::Assertions
		include Debug

		attr_reader :model, :address, :port, :connection

		def initialize(address: "hello", port: 50525, model: nil, connection: nil)
			assert (model.is_a?(Game::Model::Abstract))
			@address = address
			@port = port
			@model = model
			if connection.nil?
				@connection = XMLRPC::Server.new(port, ENV['HOSTNAME'], @@MAX_CONNECTIONS)
			else
				@connection = connection
			end
			setupHandlers()
		end

		def setupHandlers()
			@gameHandler = GameHandler.new(model)
			@lobbyHandler = LobbyHandler.new(@gameHandler)
			
			@connection.add_handler("#{address}_model", @gameHandler)
			@connection.add_handler("#{address}_lobby", @lobbyHandler)
		end

		def serve()
			@thread = Thread.new { @connection.serve }
		end
	end

	class LobbyHandler
		include Debug

		def initialize(gameHandler)
			@gameHandler = gameHandler
		end

		def lobby()
			@gameHandler.game.lobby
		end

		def update(player)
			Qt.execute_in_main_thread do
				obj = Player::Abstract::from_json(player)
				lobby.update(obj)
				@gameHandler.push_latest
			end
			return true
		end

		def rotate!()
			Qt.execute_in_main_thread do
				lobby.rotate!
				@gameHandler.push_latest
			end
			return true
		end

		def add(data)
			Qt.execute_in_main_thread do
				obj = Player::Abstract::from_json(data)
				lobby.add(obj)
				@gameHandler.push_latest
			end
			return true
		end

		def remove(data)
			Qt.execute_in_main_thread do
				obj = Player::Abstract::from_json(data)
				lobby.remove(obj)
				@gameHandler.push_latest
			end
			return true
		end
	end

	class GameHandler
		include Debug
		attr_reader :game, :stack

		def initialize(game)
			@game = game
			@model_stack = []
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
				push_latest
			end
			return true
		end

		def model_stack(index)
			return @model_stack[index]
		end

		def model_stack_size()
			return @model_stack.size
		end

		def push_model(model)
			Qt.execute_in_main_thread do
				@model_stack << model
				model = Game::Model::Abstract::from_json(model)
				@game.board = model.board
				@game.lobby = model.lobby
			end
			return true
		end

		def push_latest()
			Qt.execute_in_main_thread do
				unless @model_stack.empty?
					model = Game::Model::Abstract::from_json(@model_stack.last)
					@game.state = model.state
				end
				@model_stack << @game.to_json
				players = @game.players.map { |player| player.name }
				puts players.to_s
			end
			return true
		end

		def push(model)
			push_model(model)
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
