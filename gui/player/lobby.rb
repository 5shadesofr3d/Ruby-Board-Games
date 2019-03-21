require 'Qt'
require 'test/unit'

module LobbyColor
  GREY = "#D8DAE7"
  BLACK = "#050D10"
  LIGHT_BLUE = "#18CAE6"
  BLUE = "#34608D"
  DARK_BLUE = "#0D0C1C"
end

class PlayerLobby < Qt::Frame
  include Test::Unit::Assertions

  attr_reader :playerInfos

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    @playerInfos = []
    @layout = Qt::VBoxLayout.new(self)
    setLayout(@layout)

    addHeader
    setStyleSheet("background-color:#{LobbyColor::DARK_BLUE}; border: 1px; border-radius: 10px")

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
  @@colors = ["red", "green", LobbyColor::LIGHT_BLUE, "yellow", "pink", "magenta"]
  def initialize(parent)
    super(parent)
    setMaximumSize(75, 30)
    setMinimumSize(75, 30)
    setColor
  end

  def setColor
    setStyleSheet("background-color:#{@@colors.first};")
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

    setMaximumHeight(50)
    setMinimumHeight(50)

    @name = PlayerInfoLineEdit.new(name, self)
    @type = PlayerInfoTypeBox.new(self)
    @color = PlayerInfoColorBox.new(self)
    @wins = PlayerInfoLabel.new(wins.to_s, self)
    @loss = PlayerInfoLabel.new(ties.to_s, self)
    @ties = PlayerInfoLabel.new(loss.to_s, self)
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

  def name=(str)
    @name.text = str
  end

  def name
    return @name.text
  end

  def type
    return @type.text
  end

  def wins

  end

  def losses

  end

  def ties

  end

  def construct_player()
    # constructs and returns the player based off info
  end

  def valid?()
    # return false unless @name.is_a?(String)
    # return false unless @type.is_a?(Symbol) and (@type == :local or @type == :ai)
    # return false unless @wins.is_a?(Integer) and @wins >= 0
    # return false unless @loss.is_a?(Integer) and @loss >= 0
    # return false unless @ties.is_a?(Integer) and @ties >= 0
    return false unless @layout.is_a?(Qt::HBoxLayout)

    return true
  end

end
