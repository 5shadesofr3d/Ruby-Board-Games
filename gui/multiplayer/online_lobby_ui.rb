require 'Qt'
require 'test/unit'

require_relative '../leaderboard/leaderboard'
require_relative '../player/player_lobby'

class OnlineLobbyData
  attr_accessor :name, :num_players, :game_id

  def initialize
    @name = "Empty"
    @game_id = 0
    @num_players = 0
  end

end

class NewRoomPopup < Qt::Widget
  include Test::Unit::Assertions
  attr_accessor :roomNameText, :createRoomButton

  def initialize(width = 800, height = 600, parent = nil)
    parent != nil ? super(parent) : super()

    @verticalLayout = Qt::VBoxLayout.new(self)
    @verticalLayout.spacing = 6
    @verticalLayout.margin = 11
    @verticalLayout.objectName = "verticalLayout"
    @verticalLayout.setContentsMargins(50, 50, 50, 50)

    setLayout(@verticalLayout)
    setWindowTitle("New Room")

    setup_ui

  end

  def setup_ui

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.spacing = 6
    @horizontalLayout.objectName = "horizontalLayout"

    @roomNameLabel = Qt::Label.new
    @roomNameLabel.objectName = "roomNameLabel"
    @horizontalLayout.addWidget(@roomNameLabel)

    @roomNameText = Qt::LineEdit.new
    @roomNameText.objectName = "roomNameText"
    @horizontalLayout.addWidget(@roomNameText)

    @verticalLayout.addLayout(@horizontalLayout)

    @createRoomButton = Qt::PushButton.new
    @createRoomButton.objectName = "createRoomButton"
    @verticalLayout.addWidget(@createRoomButton)

    @roomNameLabel.text = "New Room Name:"
    @createRoomButton.text = "Create Room"


  end # setupUi

end

class OnlineLobbyUI < Qt::Frame
  attr_reader :room, :buttons, :lobby

  slots :createRoom, :addRoom, :showLeaderboard

  @@MAX_ROOM_COUNT = 5

  def initialize(width: 550, height: 400, parent: nil)
    parent != nil ? super(parent) : super()

    @lobby = LobbyRoom.new(parent: self)
    @buttons = LobbyButtons.new(parent: self)
    @room_count = 0

    setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Minimum)
    resize(width,height)
    #setMaximumWidth(550)
    #setMaximumHeight(400)

    layout = Qt::VBoxLayout.new(self)
    layout.addWidget(@lobby)
    layout.addWidget(@buttons)
    layout.setAlignment(buttons, Qt::AlignHCenter | Qt::AlignBottom)
    setLayout(layout)

    connect(buttons.add, SIGNAL("clicked()"), self, SLOT(:createRoom))
    connect(buttons.leaderboard, SIGNAL("clicked()"), self, SLOT(:showLeaderboard))
    setStyleSheet("background-color:#{LobbyColor::DARK_BLUE}; border: 1px; border-radius: 10px")
  end

  def createRoom
    popup_window = Qt::Dialog.new
    @popup = NewRoomPopup.new(popup_window)
    popup_window.setModal(true)
    @popup.show
    connect(@popup.createRoomButton,
            SIGNAL("clicked()"),
            self,
            SLOT(:addRoom))
  end

  def showLeaderboard
    # show the popup for the leaderboard
    puts "opening leaderboard"
    newapp = LeaderboardState.new
  end

  def addRoom(name = nil, game_id = nil, game_type = nil)

    if @popup.is_a? NewRoomPopup
      name = @popup.roomNameText.text.to_s
      @popup.hide
    end

    if @room_count < @@MAX_ROOM_COUNT
      @lobby.addRoom(name, game_id, game_type)
      @room_count += 1
    end
  end

  def getRooms()
    rooms = []
    @lobby.playerInfos.each {|info| players << info.construct_player(parent) }
    return players
  end

  def setPlayers(players)
    @lobby.playerInfos.each do |info|
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

class LobbyButtons < Qt::Widget
  attr_reader :join, :add, :exit, :gameID, :leaderboard

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    buttonLayout = Qt::HBoxLayout.new(self)
    #@add = LobbyButton.new("Create Room", self)
    @exit = LobbyButton.new("Exit",self)
    @join = LobbyButton.new("Join Room", self)
    @gameID = LobbyTextBox.new(self)
    @leaderboard = LobbyButton.new("Leaderboard", self)
    buttonLayout.addWidget(exit)
    buttonLayout.addWidget(add)
    buttonLayout.addWidget(join)
    buttonLayout.addWidget(gameID)
    buttonLayout.addWidget(leaderboard)
    setLayout(buttonLayout)

  end

end

class LobbyTextBox < Qt::LineEdit
  def initialize(parent)
    super(parent)

    setStyleSheet("color:white; background-color:#{LobbyColor::BLUE}; border: 1px; border-radius: 10px")

    setMaximumSize(125, 50)
    setMinimumSize(125, 50)

    font = self.font()
    font.setPixelSize(17)
    self.setFont(font)
    setAlignment(Qt::AlignCenter)

  end
end

class LobbyButton < Qt::PushButton
  def initialize(str, parent)
    super(str, parent)

    setStyleSheet("color:white; background-color:#{LobbyColor::BLUE}; border: 1px; border-radius: 10px")

    setMaximumSize(125, 50)
    setMinimumSize(125, 50)

    font = self.font()
    font.setPixelSize(17)
    self.setFont(font)
  end
end

class LobbyRoom < Qt::Frame
  include Test::Unit::Assertions

  attr_reader :lobby_infos

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    @lobby_infos = []
    @layout = Qt::VBoxLayout.new(self)

    @scrollArea = Qt::ScrollArea.new(self)
    @scrollArea.setMinimumSize(500, 500)
    @scrollArea.widgetResizable = true
    @scrollAreaWidgetContents = Qt::Widget.new()

    @scrollLayout = Qt::VBoxLayout.new(@scrollAreaWidgetContents)
    @scrollLayout.spacing = 1
    @scrollLayout.margin = 5

    setLayout(@layout)
    setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Maximum)

    addHeader
    @scrollArea.setWidget(@scrollAreaWidgetContents)
    @layout.addWidget(@scrollArea)

    assert valid?
  end

  def addHeader()
    assert valid?

    @layout.addWidget(LobbyInfoHeader.new(parent: self))

    assert valid?
  end

  def addRoom(name, game_id, game_type)
    assert valid?

    puts name.is_a? String

    if name.nil?
      lobbyInfo = LobbyInfo.new(parent: @scrollAreaWidgetContents)
    else
      lobbyInfo = LobbyInfo.new(name: name, parent: @scrollAreaWidgetContents)
    end

    if game_id.nil?
      lobbyInfo.game_id = 0
    else
      lobbyInfo.game_id = game_id
    end
    lobbyInfo.game_type = game_type
    @lobby_infos << lobbyInfo
    @scrollLayout.addWidget(lobbyInfo)
    verticalSpacer = Qt::SpacerItem.new(20, 20, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)
    @scrollLayout.addItem(verticalSpacer)

    assert lobbyInfo.is_a? LobbyInfo
    assert valid?
  end

  def valid?()
    return false unless @lobby_infos.is_a?(Array)
    return false unless @layout.is_a?(Qt::VBoxLayout)

    @lobby_infos.each {|pi| return false unless pi.is_a?(LobbyInfo)}

    return true
  end

end

class LobbyInfoLabel < Qt::Label
  def initialize(str, parent)
    super(str, parent)
    setAlignment(Qt::AlignCenter)

    font = self.font()
    font.setPixelSize(17)
    self.setFont(font)

    setMaximumWidth(75)
    setMinimumWidth(50)

    setStyleSheet("color:#{LobbyColor::GREY};")
  end
end

class LobbyInfoHeader < Qt::Widget
  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    setMaximumHeight(50)
    setMinimumHeight(50)

    name = LobbyInfoLabel.new("Name",self)
    game_id = LobbyInfoLabel.new("Game ID",self)
    #num_players = LobbyInfoLabel.new("Game Type",self)


    font = name.font
    font.bold = true

    name.font = font
    game_id.font = font
    #num_players.font = font

    name.setMaximumWidth(150)
    name.setMinimumWidth(150)

    game_id.setMaximumWidth(100)
    game_id.setMinimumWidth(100)

    #num_players.setMaximumWidth(175)
    #num_players.setMinimumWidth(175)

    @layout = Qt::HBoxLayout.new(self)
    @layout.setSpacing(20)
    @layout.addWidget(name)
    @layout.addWidget(game_id)
    #@layout.addWidget(num_players)
    setLayout(@layout)

    setStyleSheet("background-color:#{LobbyColor::DARK_BLUE};")
  end
end

class LobbyInfo < Qt::Widget
  include Test::Unit::Assertions

  def initialize(name: "Player", game_id: 0, game_type: "Connect4", parent: nil)
    parent != nil ? super(parent) : super()
    # assert wins.is_a? Integer
    # assert ties >= 0

    setMaximumHeight(50)
    setMinimumHeight(50)

    @name = LobbyInfoLabel.new(name, self)
    @game_id = LobbyInfoLabel.new(game_id.to_s, self)
    #@game_type = LobbyInfoLabel.new(game_type.to_s, self)
    setStyleSheet("background-color:#{LobbyColor::BLUE};")

    @name.setMaximumWidth(150)
    @name.setMinimumWidth(150)

    @game_id.setMaximumWidth(100)
    @game_id.setMinimumWidth(100)

    @layout = Qt::HBoxLayout.new(self)
    @layout.setSpacing(20)
    @layout.addWidget(@name)
    @layout.addWidget(@game_id)
    #@layout.addWidget(@num_players)
    setLayout(@layout)

    assert valid?
  end

  def name
    @name.text.to_s
  end

  def name=(n)
    @name.text = n
  end

  def game_id
    @game_id.text.to_s
  end

  def game_id=(id)
    @game_id.text = id
  end

  def game_type
    @game_type.text.to_s
  end

  def game_type=(num)
    @game_type = num
  end

  def close_all
    @layout.each {|e| e.hide}
  end

  def construct_lobby(parent)
    # constructs and returns the player based off info
    assert type.is_a? String

    lobby = OnlineLobbyData.new

    assert lobby.is_a? OnlineLobbyData

    #assert not(lobby.name.empty?)
    assert lobby.game_id >= 0
    assert lobby.num_players >= 0

    return lobby
  end

  def valid?


    return true
  end

end

#app = Qt::Application.new ARGV
#@main_window = Qt::MainWindow.new
#@main_window.setWindowTitle("Ruby-Board-Games")
#@main_window.setFixedSize(400, 400)
#lobby = OnlineLobbyUI.new()
#lobby.show()
#lobby.addRoom
#lobby.addRoom("Great lobby", 4)
#lobby.addRoom
#lobby.addRoom("Great lobby", 4)
#app.exec
