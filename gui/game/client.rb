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
		attr_reader :model_stack, :window_state

		@@timeout = 300 # ms

		slots "onTimeout()", "exit()"

		def initialize(username: "Godzilla", hostname: ENV['HOSTNAME'], address: "hello", port: 50525, parent: nil)
			parent != nil ? super(parent) : super()
	
			@user = Player::Local.new(username, "green")
			@user.client = self
			@machine = GameStateMachine.new(self)
			@address = address
			@hostname = hostname
			@port = port
			@model_stack = []

			setupConnections()
			setupProxy()
			setupUpdateTimer()
			setupUI()
		end

		def setupConnections()
			@server = XMLRPC::Client.new(@hostname, "/RPC2", port)
		end

		def setupProxy()
			@model = @server.proxy("#{address}_model")
			@lobby = @server.proxy("#{address}_lobby")
			@board = @server.proxy("#{address}_board")
		end

		def set_window_state(state)
			@window_state = state
		end

		def exit()
			machine.stop()
			@window_state.open_multiplayer_lobby
		end

		def setupUI()
			# puts XMLRPC::Config::ENABLE_MARSHALLING
			@view = View.new(model.rows, model.columns, parent: parent)
			@view.client = self
			@view.show()
			lobby.add(json_user)
			machine.setup()
			machine.start()
		end

		def setupUpdateTimer()
			@timer = Qt::Timer.new(self)
			@timer.setInterval(@@timeout)

			connect(@timer, SIGNAL("timeout()"), self, SLOT("onTimeout()"))
		end

		def json_user()
			return JSON.dump(@user)
		end

		def query_model()
			if @model_stack.size < model.model_stack_size
				new_model = Model::Abstract::from_json(model.model_stack(@model_stack.size))				
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
			debug() if Debug::enabled
		end

		def deliver_user()
			lobby.update(json_user)
			debug() if Debug::enabled
		end

		def update()
			debug() if Debug::enabled
			model = query_model
			@view.update(model)
			user.host = true if model.players.any? { |e| e.name == user.name and e.host }

			next_state = model.state
			machine.current_state.done if next_state != self.current_state
			puts "EXPECTED: #{next_state}, GOT: #{self.current_state}" if Debug::enabled
			debug() if Debug::enabled
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
