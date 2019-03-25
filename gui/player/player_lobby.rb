require 'Qt'
require 'test/unit'

require_relative 'abstract_player'
require_relative 'local_player'
require_relative 'ai_player'

module LobbyColor
  GREY = "#D8DAE7"
  BLACK = "#050D10"
  LIGHT_BLUE = "#18CAE6"
  BLUE = "#34608D"
  DARK_BLUE = "#0D0C1C"
end

class PlayerLobby < Qt::Frame
  attr_reader :room, :buttons

  slots :addPlayer,:removePlayer

  @@MAX_PLAYER_COUNT = 4

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    @room = PlayerRoom.new(parent: self)
    @buttons = PlayerLobbyButtons.new(parent: self)
    @player_count = 0

    setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Minimum)
    setMaximumWidth(550)
    setMaximumHeight(400)

    layout = Qt::VBoxLayout.new(self)
    layout.addWidget(room)
    layout.addWidget(buttons)
    layout.setAlignment(buttons, Qt::AlignHCenter | Qt::AlignBottom)
    setLayout(layout)

    connect(buttons.add, SIGNAL("clicked()"), self, SLOT(:addPlayer))
    connect(buttons.remove, SIGNAL("clicked()"), self, SLOT(:removePlayer))
    setStyleSheet("background-color:#{LobbyColor::DARK_BLUE}; border: 1px; border-radius: 10px")
  end

  def addPlayer()
    if @player_count < @@MAX_PLAYER_COUNT
      @room.addPlayer()
      @player_count += 1
    end
  end

  def removePlayer()
    if @player_count > 1
      @room.removePlayer()
      @player_count -= 1
    end
  end

  def getPlayers()
    players = []
    @room.playerInfos.each {|info| players << info.construct_player(parent) }
    return players
  end

  def setPlayers(players)
    @room.playerInfos.each do |info|
      player = players.shift
      info.name = player.name
      info.color = player.color
      info.type = player.class
      info.wins = player.wins
      info.losses = player.losses
      info.ties = player.ties
    end
  end

end

class PlayerLobbyButtons < Qt::Widget
  attr_reader :add, :start, :exit, :remove

    def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    buttonLayout = Qt::HBoxLayout.new(self)
    @add = PlayerLobbyButton.new("Add", self)
    @start = PlayerLobbyButton.new("Start", self)
    @exit = PlayerLobbyButton.new("Exit",self)
    @remove = PlayerLobbyButton.new("Remove",self)
    buttonLayout.addWidget(exit)
    buttonLayout.addWidget(add)
    buttonLayout.addWidget(remove)
    buttonLayout.addWidget(start)
    setLayout(buttonLayout)

  end

end

class PlayerLobbyButton < Qt::PushButton
  def initialize(str, parent)
    super(str, parent)

    setStyleSheet("color:white; background-color:#{LobbyColor::BLUE}; border: 1px; border-radius: 10px")

    setMaximumSize(75, 50)
    setMinimumSize(75, 50)

    font = self.font()
    font.setPixelSize(17)
    self.setFont(font)
  end
end

class PlayerRoom < Qt::Frame
  include Test::Unit::Assertions

  attr_reader :playerInfos

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    @playerInfos = []
    @layout = Qt::VBoxLayout.new(self)
    setLayout(@layout)

    setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Maximum)

    addHeader

    assert valid?
  end

  def addHeader()
    assert valid?

    @layout.addWidget(PlayerInfoHeader.new(parent: self))

    assert valid?
  end

  def addPlayer()
    assert valid?

    playerInfo = PlayerInfo.new(parent: self)
    @playerInfos << playerInfo
    @layout.addWidget(playerInfo)
    assert valid?
  end

  def removePlayer()
    assert valid?
    assert @playerInfos.count > 0

    player = @playerInfos.pop
    player.close
    @layout.removeWidget(player)

    assert @playerInfos.include? player == false
    assert valid?
  end

  def valid?()
    return false unless @playerInfos.is_a?(Array)
    return false unless @layout.is_a?(Qt::VBoxLayout)

    @playerInfos.each {|pi| return false unless pi.is_a?(PlayerInfo)}

    return true
  end

end

class PlayerInfoLabel < Qt::Label
  def initialize(str, parent)
    super(str, parent)
    setAlignment(Qt::AlignCenter)

    font = self.font()
    font.setPixelSize(17)
    self.setFont(font)

    setMaximumWidth(30)
    setMinimumWidth(30)

    setStyleSheet("color:#{LobbyColor::GREY};")
  end
end

class PlayerInfoLineEdit < Qt::LineEdit
  def initialize(str, parent)
    super(str, parent)
    font = self.font()
    font.setPixelSize(15)
    self.setFont(font)
    setAlignment(Qt::AlignCenter)
    setStyleSheet("color:#{LobbyColor::GREY};")
  end
end

class PlayerInfoTypeBox < Qt::ComboBox
  def initialize(parent)
    super(parent)
    font = self.font()
    font.setPixelSize(15)
    self.setFont(font)
    addItems(["Local", "Computer"])
    setStyleSheet("color:#{LobbyColor::GREY};")
  end
end

class PlayerInfoColorBox < Qt::Widget
  attr_accessor :color

  @@colors = ["red", "green", LobbyColor::LIGHT_BLUE, "yellow", "pink", "magenta"]

  def initialize(parent)
    super(parent)
    setMaximumSize(75, 30)
    setMinimumSize(75, 30)
    setColor
  end

  def updateColor
    setStyleSheet("background-color:#{@color};")
  end

  def setColor
    @color = @@colors.first
    updateColor
    @@colors.rotate!
  end

  def mousePressEvent(event)
    setColor
  end

end

class PlayerInfoHeader < Qt::Widget
  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    setMaximumHeight(50)
    setMinimumHeight(50)

    name = PlayerInfoLabel.new("Name", self)
    type = PlayerInfoLabel.new("Type", self)
    color = PlayerInfoLabel.new("Color", self)

    w = PlayerInfoLabel.new("W", self)
    l = PlayerInfoLabel.new("L", self)
    t = PlayerInfoLabel.new("T", self)

    font = name.font
    font.bold = true

    name.font = font
    type.font = font
    color.font = font
    w.font = font
    l.font = font
    t.font = font

    name.setMaximumWidth(100)
    name.setMinimumWidth(100)

    type.setMaximumWidth(100)
    type.setMinimumWidth(100)

    color.setMaximumWidth(75)
    color.setMinimumWidth(75)

    @layout = Qt::HBoxLayout.new(self)
    @layout.setSpacing(20)
    @layout.addWidget(name)
    @layout.addWidget(type)
    @layout.addWidget(color)
    @layout.addWidget(w)
    @layout.addWidget(l)
    @layout.addWidget(t)
    setLayout(@layout)

    setStyleSheet("background-color:#{LobbyColor::DARK_BLUE};")
  end
end

class PlayerInfo < Qt::Widget
  include Test::Unit::Assertions

  def initialize(name: "Player", wins: 0, loss: 0, ties: 0, color: "blue", parent: nil)
    parent != nil ? super(parent) : super()
    assert wins.is_a? Integer
    assert loss.is_a? Integer
    assert ties.is_a? Integer
    assert wins >= 0
    assert loss >= 0
    assert ties >= 0



    setMaximumHeight(50)
    setMinimumHeight(50)

    @name = PlayerInfoLineEdit.new(name, self)
    @type = PlayerInfoTypeBox.new(self)
    @color = PlayerInfoColorBox.new(self)
    @wins = PlayerInfoLabel.new(wins.to_s, self)
    @loss = PlayerInfoLabel.new(loss.to_s, self)
    @ties = PlayerInfoLabel.new(ties.to_s, self)
    setStyleSheet("background-color:#{LobbyColor::BLUE};")

    @name.setMaximumWidth(100)
    @name.setMinimumWidth(100)

    @type.setMaximumWidth(100)
    @type.setMinimumWidth(100)

    @layout = Qt::HBoxLayout.new(self)
    @layout.setSpacing(20)
    @layout.addWidget(@name)
    @layout.addWidget(@type)
    @layout.addWidget(@color)
    @layout.addWidget(@wins)
    @layout.addWidget(@loss)
    @layout.addWidget(@ties)
    setLayout(@layout)

    assert valid?
  end

  def close_all
    @layout.each {|e| e.hide}
  end

  def name=(str)
    @name.text = str
  end

  def name
    return @name.text
  end

  def color
    return @color.color
  end

  def color=(c)
    @color.color = c.name
    @color.updateColor
  end

  def type
    return @type.currentText
  end

  def type=(t)
    case t
    when LocalPlayer
      @type.currentText = "Local"
    when AIPlayer
      @type.currentText = "Computer"
    end
  end

  def wins
    return @wins.text.to_i
  end

  def wins=(w)
    @wins.text = w
  end

  def losses
    return @loss.text.to_i
  end

  def losses=(l)
    @loss.text = l
  end

  def ties
    return @ties.text.to_i
  end

  def ties=(t)
    @ties.text = t
  end

  def construct_player(parent)
    # constructs and returns the player based off info
    assert type.is_a? String

    player = nil

    case type
    when "Local"
      player = LocalPlayer.new(self.name, self.color, parent: parent)
    when "Computer"
      player = AIPlayer.new(self.name, self.color, parent: parent)
    end

    return if player == nil

    player.wins = self.wins
    player.losses = self.losses
    player.ties = self.ties


    assert player.is_a? Player
    assert player.ties >= 0
    assert player.losses >= 0
    assert player.wins >= 0

    return player
  end

  def valid?()
    # return false unless @name.is_a?(String)
    # return false unless @wins.is_a?(Integer) and @wins >= 0
    # return false unless @loss.is_a?(Integer) and @loss >= 0
    # return false unless @ties.is_a?(Integer) and @ties >= 0

    return true
  end

end
