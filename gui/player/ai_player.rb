# This is the ai player that is available if the local player can play
# NOTE: The ai player instance will have an instance of the game, which
# 		has access to the board and the model
require 'test/unit'
require 'Qt'
require_relative 'abstract_player'
# require_relative '../AI'
require_relative '../ai/ai_connect4'

class AIPlayer < Player
	# slots "play(const QKeyEvent*)"

	# attr_accessor :ai_object
	# def initialize(player_name, player_color, parent: nil, ai_type)
	# 	super(player_name, player_color, parent)
	# 	if ai_type == "Connect4"
	# 		@ai_object = AI_Connect4.new(self.game, 2, @current_chip)
	# 	elsif ai_type == "OTTO"
	# 		# make it that otto object
	# 	end
	# end

	def enable()
		# TODO: change this if not correct.
		super()
		puts "We are about to play"
		self.play("something")
		
	end

	def disable()
		puts "we are about to disable"
		super()
	end

	def play(ai_type)
		# This will return the move that the player will take. This will come
		# from a move generator for the AI
		ai_test = AI_Connect4.new(self.game, 1, @current_chip)
		# The ai player will require the ai_type to be passed through
		# TODO: To be changed possibly based off of the main gameplay code. Look
		# 		into the player_lobby code

		#pre
		assert game.is_a?(Game)

		# AI will get the next position, will be determined based on the difficulty setting
		puts "Getting Score"
		@current_column = ai_test.getBestScore()
		puts @current_column
		drop()
		puts "finish drop"
		finished()

		#post
		assert @current_column.is_a?(Numeric)
	end
end