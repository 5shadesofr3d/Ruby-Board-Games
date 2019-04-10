require_relative 'game_server_state_machine'

# Translates objects to primitive values so they can be passed
# between server and client.
module ObjectConverter

  def self.convert_to_primitive(to_conv)

    conversions = {"WaitingOnTurnState": "WaitingOnTurnState",
                   "WaitingOnAllAckState": "WaitingOnAllAcksState"}

    conversions.each do |tag, object|
      if object == to_conv.class.name
        puts "Tag: #{tag} #{object} #{conversions}"
        return tag
      end
    end

    return nil
  end

end

# Returns symbols
# game = GameServerStateMachine.new([])
# puts ObjectConverter.convert_to_primitive(game.current_state_instance).is_a? Symbol