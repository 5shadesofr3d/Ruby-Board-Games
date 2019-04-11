# This is the local player object. It is inherited from the player abstract class
require 'Qt'
require 'test/unit'
require_relative 'abstract'

module Player
	class Local < Abstract

		slots "play(const QKeyEvent*)", :acknowledge_keyboard, :ignore_keyboard

		def enable
			super()
			assert game.is_a? Game::Model::Abstract
			assert game.board.is_a? Board::Model

			connect(controller, SIGNAL("translateStarted()"), self, SLOT("ignore_keyboard()"))
			connect(controller, SIGNAL("translateCompleted()"), self, SLOT("acknowledge_keyboard()"))

			acknowledge_keyboard
		end

		def disable
			assert game.is_a? Game::Model::Abstract
			assert game.board.is_a? Board::Model

			super()

			disconnect(controller, SIGNAL("translateStarted()"), self, SLOT("ignore_keyboard()"))
			disconnect(controller, SIGNAL("translateCompleted()"), self, SLOT("acknowledge_keyboard()"))

			ignore_keyboard
		end

		def acknowledge_keyboard
			assert game.is_a? Game::Model::Abstract
			connect(game.view, SIGNAL("keyPressed(const QKeyEvent*)"), self, SLOT("play(const QKeyEvent*)"))
		end

		def ignore_keyboard
			assert game.is_a? Game::Model::Abstract
			disconnect(game.view, SIGNAL("keyPressed(const QKeyEvent*)"), self, SLOT("play(const QKeyEvent*)"))
		end

		def play(event)
			# Position is in terms of the column position on the board
			#pre
			assert game.is_a?(Game::Model::Abstract)
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
			assert key_event.is_a?(Qt::KeyEvent)

			case key_event.key
			when Qt::Key_Up.value
				up()
			when Qt::Key_Down.value
				down()
			when Qt::Key_Left.value
				left()
			when Qt::Key_Right.value
				right()
			when Qt::Key_Space.value
				tile = nil
				begin
					tile = game.board.next_empty(current_column)
				rescue Board::Iterator::ColumnFullError
					tile = nil
					puts "Column full, try again"
				end

				if tile != nil
					drop()
				end
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
end