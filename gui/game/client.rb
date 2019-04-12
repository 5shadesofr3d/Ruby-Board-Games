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
		attr_reader :model, :lobby, :board, :view
		attr_reader :user, :machine, :timer
		attr_reader :model_stack

		slots "onTimeout()"

		def initialize(username: "Godzilla", address: "hello", port: 50525, parent: nil)
			parent != nil ? super(parent) : super()
	
			@user = Player::Local.new(username, "green")
			@user.client = self
			@machine = GameStateMachine.new(self)
			@address = address
			@port = port
			@model_stack = []

			setupConnections()
			setupProxy()
			setupUpdateTimer()
			setupUI()
		end

		def setupConnections()
			@server = XMLRPC::Client.new(ENV['HOSTNAME'], "/RPC2", port)
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
			machine.setup()
			machine.start()
		end

		def setupUpdateTimer()
			@timer = Qt::Timer.new(self)
			@timer.setInterval(1000)

			connect(@timer, SIGNAL("timeout()"), self, SLOT("onTimeout()"))
		end

		def json_user()
			return JSON.dump(@user)
		end

		def query_model()
			if @model_stack.size < model.model_stack_size
				new_model = Game::Model::Abstract::from_json(model.model_stack(@model_stack.size))				
				@model_stack << new_model
				return new_model
			else
				return current_model
			end
		end

		def current_model()
			return @model_stack.last
		end

		def current_state()
			return machine.current_state.clazz
		end

		def push(model: self.current_model)
			model.state = current_state
			@model.push(model.to_json)
			debug()
		end

		def deliver_user()
			lobby.update(json_user)
			debug()
		end

		def update()
			debug()
			model = query_model
			@view.update(model)
			user.host = true if model.players.any? { |e| e.name == user.name and e.host }

			next_state = model.state
			machine.current_state.done if next_state != self.current_state
			puts "EXPECTED: #{next_state}, GOT: #{self.current_state}"
			debug()
		end

		def debug()
			puts "USER: #{user.name}, HOST: #{user.host}"
			puts "SERVER SIZE: #{@model.model_stack_size}, LOCAL_SIZE: #{@model_stack.size}"
			players = self.current_model.players.map { |player| player.name } unless @model_stack.empty?
			puts "PLAYER ORDER = #{players.to_s}"
		end

		def onTimeout()
			update()
		end

		def quit()
			lobby.remove(json_user)
		end
	end
end
