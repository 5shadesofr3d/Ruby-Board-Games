require 'test/unit'
require_relative '../player'
require_relative '../debug'

module Lobby
	class Model
		include Test::Unit::Assertions
		include Debug

		attr_reader :view, :players

		def initialize(players: [], view: nil)
			@players = players
			self.view = view
		end

		def view?()
			return @view.is_a?(Lobby::View)
		end

		def add(player)
			assert player.is_a?(Player::Abstract)
			@players << player
		end

		def remove(player)
			assert player.is_a?(Player::Abstract)
			@players.delete_if { |element| element.name == player.name }
		end

		def view=(view)
			assert (view.is_a?(Lobby::View) or view == nil)
			@view = view
			notify()
		end

		def notify()
			return unless view?
			view.setAll(@players)
		end
	end
end