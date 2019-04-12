# This file contains all of the widget classes that will show the leaderboard table
# and the visualizer

# Taken from the player_lobby.rb files

# The following may need to be created, only if the table widget does not work

# Leaderboard Table
# Leaderboard Header
# Leaderboard sort/search buttons
# Leaderboard back button (maybe)
# Leaderboard row values (for each column)
	# => For the rows, there needs to be a limit set if scrolling is not available
	# => Think page by page
	# => For now only show possible the top 10 players, then the ranked placement of the player in the bottom
require 'Qt'
require 'test/unit'
# require_relative '../GameData'
require_relative '../settings'

module LeaderboardColor
  GREY = "#D8DAE7"
  BLACK = "#050D10"
  LIGHT_BLUE = "#18CAE6"
  BLUE = "#34608D"
  DARK_BLUE = "#0D0C1C"
end

class Leaderboard < Qt::Widget
  include Test::Unit::Assertions

  attr_reader :table, :buttons

  def initialize(width = 800, height = 600, parent = nil)
    assert width.is_a? Integer
    assert height.is_a? Integer
    assert width > 0
    assert height > 0
    parent != nil ? super(parent) : super()

    @parent = parent

    @table = LeaderboardTable.new(parent: parent)
    @buttons = LeaderboardButtons.new(parent: self)

    @layout = Qt::VBoxLayout.new(self)
    @layout.addWidget(table)
    @layout.addWidget(buttons)
    @layout.setAlignment(buttons, Qt::AlignHCenter | Qt::AlignBottom)
    setLayout(@layout)
    setScreenSize(width,height)
    setWindowTitle("Leaderboard")
    # drawMenu
    # setup_ui

    show
    assert @layout.is_a? Qt::VBoxLayout
  end

  # Sets the size of the main window and the title screen
  def setScreenSize(width, height)
    assert width.is_a?(Integer) and width.between?(100, 1920)
    assert height.is_a?(Integer) and height.between?(100, 1080)

    resize(width, height)
    @parent.setFixedSize(width, height)

  	assert width() == width
  	assert height() == height
  end

  # def setupUI()
  # 	# TODO: need to verify that these asserts are valid
  #   # Set the font
  #   @font = Qt::Font.new 
  #   @font.family = "Serif"
  #   @font.pointSize = 20
  #   @font.bold = true
  #   @font.weight = 75

  #   @font1 = Qt::Font.new
  #   @font1.family = "Sans Serif"
  #   @font1.pointSize = 16

  # 	# NOTE: might need to look into the QtTableWidget for more inspiration
  # 	# assert leaderboardWindow.is_a? Qt::MainWindow
  #   # assert GameData.leaderboard.instance.valid?

  # 	# setup the UI interface for the leaderboard
   
  # 	# setup the leaderboard Table

  # 	# Setup the textbox for searching

  # 	# setup the list of possible ways to sort
  # 	# e.g. Wins, alphabetical, losses, ties (might be within table settings in Qt??)

  # 	# setup the buttons to do tasks

  # 	draw_color

  # 	# assert leaderboardTable.visible = true
  # 	# assert GameData.checkData = already checked
  # 	# assert leaderboardTable.width = tableWidth (for all of the column names)
  # 	# assert leaderboardTable.rows <= maxVisible rows
  # 	assert @bBack.is_a? Qt::PushButton
  #   assert @bSearch.is_a? Qt::PushButton
  #   assert @bSort.is_a? Qt::PushButton
  #   assert @SortComboBox.is_a? Qt::ComboBox
  #   assert @SearchTextBox.is_a? Qt::TextEdit
  # end

  # def setup_ui
  # 	setupUI
  # end

  def draw_color
  	theme = Settings.instance.theme

    # Set the background of the window.
    setStyleSheet("background-color: #{theme.color[:background]};")

  end

  def valid?
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::VBoxLayout
    return true
  end

  def initialize_ui
    # assert GameData.instance.valid?
    assert valid?
    # assert LeaderboardTable.exists? <= Need this to put data in

    # Get the instance of the game data that has been saved
    # TODO: this is the SQL query controller getting all the data from the server
 
 	# leaderBoardData = GameData.Leaderboard.instance?

 	# set the values to the leaderboard table
 	# tableCells.content = leaderBoardData.tabular

 	# ensure that all of the necessary boxes are empty (search and sort)
  end

end

class LeaderboardButtons < Qt::Widget
  attr_reader :bBack
  attr_reader :bSearch
  attr_reader :bSort
  attr_reader :SortComboBox
  attr_reader :SearchTextBox

  def initialize(parent: nil)
    parent != nil ? super(parent) : super()

    buttonLayout = Qt::HBoxLayout.new(self)
    @bSearch = LeaderboardButton.new("Search", self)
    @bSort = LeaderboardButton.new("Sort", self)
    @SortComboBox = LeaderboardComboBox.new(self)
    @SearchTextBox = LeaderboardLineEdit.new("Enter keywords", self)
    buttonLayout.addWidget(@SortComboBox)
    buttonLayout.addWidget(@bSort)
    buttonLayout.addWidget(@SearchTextBox)
    buttonLayout.addWidget(@bSearch)
    setLayout(buttonLayout)
  end
end

class LeaderboardButton < Qt::PushButton
  def initialize(str, parent)
  	theme = Settings.instance.theme
    super(str, parent)

    setStyleSheet("background-color: #{theme.color[:button]};
                    color: #{theme.color[:text]};
                    border-radius: 5px;")

    setMaximumSize(75, 50)
    setMinimumSize(75, 50)

    font = self.font()
    font.setPixelSize(17)
    self.setFont(font)
  end
end

class LeaderboardComboBox < Qt::ComboBox
	def initialize(parent)
		theme = Settings.instance.theme
		super(parent)
		font = self.font()
		font.setPixelSize(15)
		self.setFont(font)
		addItems(["Wins", "Loses", "Ties", "AlphaNum"])
		setStyleSheet("QComboBox { border: 1px solid gray;
                               border-radius: 5px;
                               padding: 1px 18px 1px 3px;
                               min-width: 6em; }
                   QComboBox:editable { background-color: #{theme.color[:button]};" +
                                       "color: #{LeaderboardColor::BLACK}; }")
	end
end

class LeaderboardLineEdit < Qt::LineEdit
	def initialize(str, parent)
		theme = Settings.instance.theme
		super(str, parent)
		font = self.font()
		font.setPixelSize(15)
		self.setFont(font)
		setAlignment(Qt::AlignCenter)
		setStyleSheet("color: #{LeaderboardColor::BLACK}; }")
	end
end

class LeaderboardTable < Qt::Frame
	include Test::Unit::Assertions

	attr_reader :rankings

	def initialize(parent:nil)
		parent != nil ? super(parent) : super()

		@rankings = [] # This is to hold all of the ranking table
		@layout = Qt::VBoxLayout.new(self)
		setLayout(@layout)

		# Create and add the header
		@layout.addWidget(LeaderboardInfoHeader.new(parent: self))

		setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Maximum)

		assert valid?
	end

	def add_rankings(rankingArray)
		assert valid?
		@rankings = rankingArray
		# Add all of the rankings individually to the frame
		@rankings.each do |rankInfo|
			@layout.addWidget(rankInfo)
		end

		assert valid?
	end

	def valid?()
		return false unless @rankings.is_a?(Array)
		return false unless @layout.is_a?(Qt::VBoxLayout)

		@rankings.each {|r| return false unless r.is_a?(RankRowInfo)}

		return true
	end
end

class LeaderboardLabel < Qt::Label
	def initialize(str, parent)
		super(str, parent)
		setAlignment(Qt::AlignCenter)

		font = self.font()
		font.setPixelSize(17)
		self.setFont(font)
		setMaximumWidth(60)
    	setMinimumWidth(60)

    	theme = Settings.instance.theme
    	setStyleSheet("color: #{theme.color[:text]}; }")
    end
end


class LeaderboardInfoHeader < Qt::Widget
	def initialize(parent:nil)
		parent != nil ? super(parent) : super()

	    setMaximumHeight(50)
	    setMinimumHeight(50)

	    rank = LeaderboardLabel.new("Rank", self)
	    name = LeaderboardLabel.new("Name", self)
	    wins = LeaderboardLabel.new("Wins", self)
	    loses = LeaderboardLabel.new("Loses", self)
	    ties = LeaderboardLabel.new("Ties", self)

	    font = name.font
	    font.bold = true

	    rank.font = font
	    name.font = font
	    wins.font = font
	    loses.font = font
	    ties.font = font

	    rank.setMaximumWidth(100)
	    rank.setMinimumWidth(100)

	    name.setMaximumWidth(100)
	    name.setMinimumWidth(100)

	    @layout = Qt::HBoxLayout.new(self)
	    @layout.setSpacing(20)
	    @layout.addWidget(rank)
	    @layout.addWidget(name)
	    @layout.addWidget(wins)
	    @layout.addWidget(loses)
	    @layout.addWidget(ties)
	    setLayout(@layout)

	    theme = Settings.instance.theme
	    setStyleSheet("background-color: #{theme.color[:background]};")
	end
end