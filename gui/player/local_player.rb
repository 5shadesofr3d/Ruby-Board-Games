# This is the local player object. It is inherited from the player abstract class
require 'test/unit'
require 'Qt'
require_relative 'player_abstract'

class LocalPlayer < Player

	def get_move(current_position, event)
		# Position is in terms of the column position on the board
		
		#pre
		assert current_position.is_a? Numeric and current_position >= 0
		assert event.is_a? Qt::QKeyEvent or event.is_a? Qt::QMouseEvent

		new_position = current_position
		# Get the event type to check what value must be returned
		if event.type == Qt::QKeyEvent
			# get the new column position from the keypress
			new_position = self.get_keyboard_press(current_position, event)
		elsif event.type == Qt::QMouseEvent
			new_position = self.get_mouse_click(current_position, event)

		#post
		assert new_position.is_a? Numeric

		return new_position
	end

	def get_keyboard_press(current_position, key_event)
		# This is going to get the input from the keyboard from what the player should
		# be doing. This is going to return the Key press ENUM

		# The following are the possible enums
		# Qt::Key_Left
		# Qt::Key_Right
		# Qt::Key_Space

		#pre
		assert current_position.is_a? Numeric and current_position >= 0
		assert event.is_a? Qt::QKeyPress

		new_position
		if key_event.key == Qt::Key_Left
			new_position = current_position - 1
		elsif key_event.key == Qt::Key_Right
			new_position = current_position + 1
		elsif key_event.key == Qt::Key_Space
			new_position = -1

		#post
		assert new_position.is_a? Numeric

		return new_position
	end

	def get_mouse_click(current_position, event)
		# this will change the position of the cursor based on wherever the mouse clicked

		#pre
		assert current_position.is_a? Numeric and current_position >= 0
		assert event.is_a? Qt::QMouseEvent
		# assert Game.Settings.Window exists and are valid numbers

		# handle the mouse event. Will return a new position
		new_position = 1 # will add rest of functionality later

		#post
		assert new_position.is_a? Numeric
		return new_position
	end

end