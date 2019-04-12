require 'Qt'
require 'test/unit'
require 'xmlrpc/config'
require 'xmlrpc/server'
require_relative 'model'
require_relative 'view'
require_relative '../player'
require_relative '../debug'
require_relative '../states/game_states'

module Game
	class Client < Qt::Object
		include Test::Unit::Assertions
		include Debug
		attr_reader :address, :port, :server, :connection
		attr_reader :model, :lobby, :board, :view, :user, :machine

		def initialize(username: "Godzilla", address: "hello", port: 8080, parent: nil)
			parent != nil ? super(parent) : super()
	
			@user = Player::Local.new(username, "green")
			@user.client = self
			@machine = GameStateMachine.new(self)
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
			@model = @server.proxy("#{address}_model")
			@lobby = @server.proxy("#{address}_lobby")
			@board = @server.proxy("#{address}_board")
		end

		def setupUI()
			# puts XMLRPC::Config::ENABLE_MARSHALLING
			@view = Game::View.new(model.rows, model.columns)
			@view.client = self
			@view.show()
			lobby.add(json_user)
			update()
			machine.setup()
			machine.start()
		end

		def json_user()
			return JSON.dump(@user)
		end

		def query_model()
			return Game::Model::Abstract::from_json(model.instance)
		end

		def deliver()
			new_model = user.model # the model changed by user
			model.update(new_model.to_json)
		end

		def deliver_user()
			lobby.update(json_user)
		end

		def update()
			@view.update(query_model)
		end

		def quit()
			lobby.remove(json_user)
		end
	end
end