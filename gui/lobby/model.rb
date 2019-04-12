require 'test/unit'
require_relative '../player'
require_relative '../debug'

module Lobby
	class Model
		include Test::Unit::Assertions
		include Debug

		attr_reader :views, :players

		def initialize(players: [], views: [])
			@players = players
			@views = views
		end

		def to_json(options={})
			return {
				'p' => @players
			}.to_json
		end

		def self.from_json(string)
			data = JSON.load string
			players = data['p'].map { |player| Player::Abstract::from_json(player.to_json) }
			return new players: players
		end

		def add(player)
			assert player.is_a?(Player::Abstract)
			return if @players.any? { |e| e.name == player.name }
			@players << player
			player.host = true if @players.first == player
		end

		def update(player)
			assert player.is_a?(Player::Abstract)
			@players.map! { |e| e.name == player.name ? player : e }
		end

		def remove(player)
			assert player.is_a?(Player::Abstract)
			@players.delete_if { |e| e.name == player.name }
		end

		def addView(view)
			assert view.is_a?(Lobby::View)
			@views << view
			notify()
		end

		def notify()
			views.each { |view| view.update(self) }
		end
	end
end