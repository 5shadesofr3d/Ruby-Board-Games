# This is the local player object. It is inherited from the player abstract class
require 'test/unit'
require 'Qt'
require_relative 'abstract_player'

class LocalPlayer < Player

	slots "play(const QKeyEvent*)", :acknowledge_keyboard, :ignore_keyboard

	def enable()
		super()

		connect(game.board, SIGNAL("translateStarted()"), self, SLOT("ignore_keyboard()"))
		connect(game.board, SIGNAL("translateCompleted()"), self, SLOT("acknowledge_keyboard()"))

		acknowledge_keyboard
	end

	def disable()
		super()

		disconnect(game.board, SIGNAL("translateStarted()"), self, SLOT("ignore_keyboard()"))
		disconnect(game.board, SIGNAL("translateCompleted()"), self, SLOT("acknowledge_keyboard()"))

		ignore_keyboard
	end

	def acknowledge_keyboard()
		connect(game, SIGNAL("keyPressed(const QKeyEvent*)"), self, SLOT("play(const QKeyEvent*)"))
	end

	def ignore_keyboard()
		disconnect(game, SIGNAL("keyPressed(const QKeyEvent*)"), self, SLOT("play(const QKeyEvent*)"))
	end

	def play(event)
		# Position is in terms of the column position on the board
		#pre
		assert game.is_a?(Game)
		assert event.is_a?(Qt::KeyEvent) or event.is_a?(Qt::MouseEvent)

		handle_key(event) # or self.handle_mouse(event)

		#post
		assert current_column.is_a?(Numeric)
	end

	def handle_key(key_event)
		# This is going to get the input from the keyboard from what the player should
		# be doing. This is going to return the Key press ENUM

		# The following are the possible enums
		# Qt::Key_Left
		# Qt::Key_Right
		# Qt::Key_Space

		#pre
		assert current_column.is_a?(Numeric) and current_column >= 0

		case key_event.key
		when Qt::Key_Left.value
			left()
		when Qt::Key_Right.value
			right()
		when Qt::Key_Space.value
			drop()
		end

		#post
		assert current_column.is_a?(Numeric)
	end

	def handle_mouse(current_position, event)
		# this will change the position of the cursor based on wherever the mouse clicked

		#pre
		assert current_column.is_a?(Numeric) and current_column >= 0
		assert event.is_a?(Qt::MouseEvent)
		# assert Game.Settings.Window exists and are valid numbers

		# handle the mouse event. Will return a new position

		#post
		assert current_column.is_a?(Numeric)
		return false
	end
end