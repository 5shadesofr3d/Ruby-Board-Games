# This is the local player object. It is inherited from the player abstract class
require 'test/unit'
require 'Qt'
require_relative 'player'

class LocalPlayer < Player

	def enable()
		super
		setFocus(Qt::OtherFocusReason)
		setFocusPolicy(Qt::StrongFocus)
	end

	def disable()
		super
		setFocusPolicy(Qt::NoFocus)
	end

	def keyPressEvent(event)
		assert game.is_a?(Game)
		super() unless play(event)
	end

	def play(event)
		# Position is in terms of the column position on the board
		
		#pre
		assert event.is_a?(Qt::KeyEvent) or event.is_a?(Qt::MouseEvent)

		# Get the event type to check what value must be returned
		result = self.handle_key(event) or self.handle_mouse(event)

		#post
		assert current_column.is_a?(Numeric)
		return result
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
			return true
		when Qt::Key_Right.value
			right()
			return true
		when Qt::Key_Space.value
			drop()
			return true
		end

		#post
		assert current_column.is_a?(Numeric)
		return false
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