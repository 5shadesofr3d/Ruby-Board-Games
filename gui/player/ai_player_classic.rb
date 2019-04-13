# This is the ai player that is available if the local player can play
# NOTE: The ai player instance will have an instance of the game, which
# 		has access to the board and the model
require 'test/unit'
require 'Qt'
require_relative 'abstract_player_classic'
# require_relative '../ai'
require_relative '../ai/ai_connect4'
require_relative '../ai/ai_otto'
require_relative '../settings'

class AIPlayer < Player::Player
	# slots "play(const QKeyEvent*)"

	attr_accessor :ai_object

	def enable()
		super()
		self.play()
		
	end

	# def disable()
	# 	puts "we are about to disable"
	# 	super()
	# end

	def play
		# This will return the move that the player will take. This will come
		# from a move generator for the AI
		# The ai player will require the ai_type to be passed through
		# TODO: To be changed possibly based off of the main gameplay code. Look
		# 		into the player_lobby code

		ai_type = Settings.instance.game_mode
		if ai_type == :Connect4
			@ai_object = AI_Connect4.new(@game, 2, @current_chip)
		elsif ai_type == :TOOT
			# make it that otto object
			@ai_object = AI_OTTO.new(@game, 1, @current_chip)
			@ai_object.player_goal = @goal
		end

		#pre
		assert game.is_a?(Game)

		# AI will get the next position, will be determined based on the difficulty setting
		@current_column = @ai_object.getBestScore()
		if @ai_object.is_a?(AI_OTTO)
			# random value
			temp_num = rand(2)
			if temp_num == 0
				up()
			end
		end
		drop()
		finished()

		#post
		assert @current_column.is_a?(Numeric)
	end
end