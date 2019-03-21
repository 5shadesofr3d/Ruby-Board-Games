require 'Qt'

class PlayerLobby < Qt::Widget
  include Test::Unit::Assertions

  attr_reader :playerInfos

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    @playerInfos = []
    @layout = Qt::VBoxLayout.new(self)
    setLayout(@layout)

    assert valid?
  end

  def addPlayer()
    assert valid?

    playerInfo = PlayerInfo.new(parent: self)
    @playerInfos << playerInfo
    @layout.addWidget(playerInfo)

    assert valid?
  end

  def valid?()
    return false unless @playerInfos.is_a?(Array)
    return false unless @layout.is_a?(Qt::VBoxLayout)

    @playerInfos.each {|pi| return false unless pi.is_a?(PlayerInfo)}

    return true
  end

end

class PlayerInfo < Qt::Widget
  attr_accessor :name, :type, :wins, :loss, :ties, :color

  def initialize(name: "Player", type: :local, wins: 0, loss: 0, ties: 0, color: Qt::blue, parent: nil)
    parent != nil ? super(parent) : super()

    @name = name
    @type = type
    @wins = wins
    @loss = ties
    @ties = loss
    @color = color

    @layout = Qt::HBoxLayout.new(self)
    
    setLayout(@layout)

    assert valid?
  end

  def construct_player()
    # constructs and returns the player based off info
  end

  def valid?()
    return false unless @name.is_a?(String)
    return false unless @type.is_a?(Symbol) and (@type == :local or @type == :ai)
    return false unless @wins.is_a?(Integer) and @wins >= 0
    return false unless @loss.is_a?(Integer) and @loss >= 0
    return false unless @ties.is_a?(Integer) and @ties >= 0
    return false unless @layout.is_a?(Qt::HBoxLayout)

    return true
  end

end
