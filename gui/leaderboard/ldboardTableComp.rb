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
require_relative '../../storage/SQLController'

module LeaderboardColor
  GREY = "#D8DAE7"
  BLACK = "#050D10"
  LIGHT_BLUE = "#18CAE6"
  BLUE = "#34608D"
  DARK_BLUE = "#0D0C1C"
  WHITE = "#FFFFFF"
end

class Leaderboard < Qt::Widget
  include Test::Unit::Assertions
  attr_reader :table, :buttons

  slots :sortData, :searchData

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

    initialize_ui

    # initialize the buttons to handle a response
    connect(buttons.bSort, SIGNAL("clicked()"), self, SLOT(:sortData))
    connect(buttons.bSearch, SIGNAL("clicked()"), self, SLOT(:searchData))

    draw_color

    show
    assert @layout.is_a? Qt::VBoxLayout
    assert valid?
  end

  def sortData()
  	# Right now puts that stuff from text
  	# TODO: Add server functionality here to get the list of dictionaries
  	sql = SQLController.new

  	puts "sorting"

  	orderStr = "ORDER BY "
  	sortText = @buttons.SortComboBox.currentText.to_s

  	if sortText == "Wins"
  		orderStr += "wins DESC"
  	elsif sortText == "Losses"
  		orderStr += "losses DESC"
  	elsif sortText == "Ties"
  		orderStr += "ties DESC"
  	elsif sortText == "AlphaNum"
  		orderStr += "name"
  	end

  	# TODO: query from the server HERE
  	puts orderStr
  	puts sql.get_leaderboard(extraQueryStr: orderStr)
  	@table.add_rankings(sql.get_leaderboard(extraQueryStr: orderStr))
  end

  def searchData()
  	# Right now prints to command line
  	puts @buttons.SearchTextBox.text
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

  def draw_color
  	theme = Settings.instance.theme

    # Set the background of the window.
    setStyleSheet("background-color: #{theme.color[:background]};")

  end

  def valid?()
    return false unless width().is_a?(Integer) and width().between?(100, 1920)
    return false unless height().is_a?(Integer) and height().between?(100, 1080)
    return false unless @layout.is_a? Qt::VBoxLayout
    return false unless @table.is_a? LeaderboardTable and @buttons.is_a? LeaderboardButtons
    return true
  end

  def initialize_ui
    # assert GameData.instance.valid?
    assert valid?
    # assert LeaderboardTable.exists? <= Need this to put data in

    # TODO: Need to get the leaderboard data from the server
    # TODO: Implement the server code here VISHAL
    # EXAMPLE USAGE #####
	sql = SQLController.new
	# sql.insert_new_player("gregg") ##Creates new player with 0 for all stats
	# sql.insert_new_player("steve")
	# sql.update_player("gregg") ##UPDATE DEFAULTS TO WINS
	# sql.update_player("steve","losses")
	# sql.update_player("steve","ties")
	rankings = sql.get_leaderboard
	@table.add_rankings(rankings)
	######################
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
		addItems(["Wins", "Losses", "Ties", "AlphaNum"])
		setStyleSheet("QComboBox { border: 1px solid gray;
                               border-radius: 5px;
                               padding: 1px 18px 1px 3px;
                               min-width: 6em; }
                   QComboBox:editable { background-color: #{theme.color[:button]};" +
                                       "color: #{LeaderboardColor::WHITE}; }")
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
		setStyleSheet("color: #{LeaderboardColor::WHITE}; }")
	end
end

class LeaderboardTable < Qt::Frame
	include Test::Unit::Assertions

	attr_accessor :rankings, :rows

	def initialize(parent:nil)
		parent != nil ? super(parent) : super()

		@rankings = []
		@layout = Qt::VBoxLayout.new(self)
		setLayout(@layout)

		# Create and add the header
		@layout.addWidget(LeaderboardInfoHeader.new(parent: self))

		setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Maximum)

		assert valid?
	end

	def add_rankings(rankingArray)
		assert valid?
		assert rankingArray.is_a?(Array)
		rankingArray.each {|ra| return false unless ra.is_a?(Hash)}
			
		# make rankings empty
		clear

		# add all of the player data rows from the database
		rankingArray.each_with_index do |pData, index|
			@rankings << RankRowInfo.new(index+1, pData, self)
		end
		# Add all of the rankings individually to the frame
		@rankings.each do |rankInfo|
			@layout.addWidget(rankInfo)
		end
		@rankings.each {|r| return false unless r.is_a?(RankRowInfo)}
		assert valid?
	end

	def clear()
		assert valid?
		@rankings.each do |rankRow|
			rankRow.close
			@layout.removeWidget(rankRow)
		end
		@rankings.clear
		assert valid?
	end


	def valid?()
		return false unless @rankings.is_a?(Array)
		return false unless @layout.is_a?(Qt::VBoxLayout)

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

class RankRowInfo < Qt::Widget
	include Test::Unit::Assertions

	def initialize(rank, playerData, parent)
		parent != nil ? super(parent) : super()
		assert rank.is_a? Integer
		assert playerData.is_a? Hash
		assert rank > 0

		setMaximumHeight(50)
		setMinimumHeight(50)

		@rank = LeaderboardLabel.new(rank.to_s, self)
		@name = LeaderboardLabel.new(playerData["name"], self)
		@wins = LeaderboardLabel.new(playerData["wins"].to_s, self)
		@losses = LeaderboardLabel.new(playerData["losses"].to_s, self)
		@ties = LeaderboardLabel.new(playerData["ties"].to_s, self)

		theme = Settings.instance.theme
		setStyleSheet("background-color: #{theme.color[:background]};")
		@name.setMaximumWidth(100)
    	@name.setMinimumWidth(100)

    	@layout = Qt::HBoxLayout.new(self)
    	@layout.setSpacing(20)
    	@layout.addWidget(@rank)
    	@layout.addWidget(@name)
    	@layout.addWidget(@wins)
    	@layout.addWidget(@losses)
    	@layout.addWidget(@ties)
    	setLayout(@layout)

    	# assert valid?
    end

    def valid?()
    	return false unless @rank.is_a? LeaderboardLabel
    	return false unless @name.is_a? LeaderboardLabel
    	return false unless @wins.is_a? LeaderboardLabel
    	return false unless @losses.is_a? LeaderboardLabel
    	return false unless @ties.is_a? LeaderboardLabel
    end
end