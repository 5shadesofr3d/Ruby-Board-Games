# This is the leaderboard class that will be able to display the entire list of
# players who have made it to the leaderboard
require 'Qt'
require 'test/unit'

class Leaderboard < Qt::Widget
  include Test::Unit::Assertions

  attr_reader :bBack
  attr_reader :bSearch
  attr_reader :bSort
  attr_reader :SortComboBox
  attr_reader :SearchTextBox

  def initialize(width = 800, height = 600, parent = nil)
    assert width.is_a? Integer
    assert height.is_a? Integer
    assert width > 0
    assert height > 0
    parent != nil ? super(parent) : super()

    @parent = parent
    @layout = Qt::VBoxLayout.new(self)
    @layout.setSpacing(height/6) #This value seems to use the screen spae well
    setLayout(@layout)
    setScreenSize(width,height)
    setWindowTitle("Leaderboard")
    # show
    # drawMenu
    # draw_color
    setup_ui

    # @parent.showFullScreen
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

  def setupUI()
  	# TODO: need to verify that these asserts are valid
  	# assert leaderboardWindow.is_a? Qt::MainWindow
    # assert GameData.leaderboard.instance.valid?

  	# setup the UI interface for the leaderboard

  	# setup the leaderboard Table

  	# Setup the textbox for searching

  	# setup the list of possible ways to sort
  	# e.g. Wins, alphabetical, losses, ties (might be within table settings in Qt??)

  	# setup the buttons to do tasks

  	draw_color

  	assert @bBack.is_a? Qt::PushButton
    assert @bSearch.is_a? Qt::PushButton
    assert @bSort.is_a? Qt::PushButton
    assert @SortComboBox.is_a? Qt::ComboBox
    assert @SearchTextBox.is_a? Qt::TextEdit
  end

  def setup_ui
  	setupUI
  end

  def draw_color

    theme = Settings.instance.theme

    # Set the background of the window.
    setStyleSheet("background-color: #{theme.color[:background]};")

    button_style = "background-color: #{theme.color[:button]};
                    color: #{theme.color[:text]};
                    border-radius: 5px;"

    text_style = "color: #{theme.color[:text]}; "

    combo_style = "QComboBox { border: 1px solid gray;
                               border-radius: 5px;
                               padding: 1px 18px 1px 3px;
                               min-width: 6em; }
                   QComboBox:editable { background-color: #{theme.color[:button]};" +
                                       "color: #{theme.color[:text]}; }"

    text_box_style = nil # TODO: style the textbox

    @bBack.setStyleSheet(button_style)
    @bSearch.setStyleSheet(button_style)
    @bSort.setStyleSheet(button_style)
    @SortComboBox.setStyleSheet(combo_style)
    @SearchTextBox.setStyleSheet(text_box_style)

    # set the style for all of the texts throughout the leaderboard
    # The following are the texts required that will need to be styled
    # => Leaderboard title
    # => Leaderboard column titles

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

    # Get the instance of the game data that has been saved
    # TODO: this is the SQL query controller getting all the data from the server
 
 	# leaderBoardData = Gamedata.Leaderboard.instance?

 	# set the values to the leaderboard table
 	# tableCells.content = leaderBoardData.tabular

 	# ensure that all of the necessary boxes are empty (search and sort)
  end

  def retranslateUi
    # assert settingsWindow.is_a? Qt::MainWindow

    # TODO: change this to include all of the necessary items for the leaderboard
    windowTitle = Qt::Application.translate("LeaderboardWindow", "Leaderboard", nil, Qt::Application::UnicodeUTF8)
    @SearchTextBox.text = Qt::Application.translate("LeaderboardWindow", "Insert search keywords here", nil, Qt::Application::UnicodeUTF8)
    @SortComboBox.insertItems(0, [Qt::Application.translate("LeaderboardWindow", "Wins", nil, Qt::Application::UnicodeUTF8),
                                  Qt::Application.translate("LeaderboardWindow", "Loses", nil, Qt::Application::UnicodeUTF8),
                              	  Qt::Application.translate("LeaderboardWindow", "Ties", nil, Qt::Application::UnicodeUTF8),
                              	  Qt::Application.translate("LeaderboardWindow", "Alpha", nil, Qt::Application::UnicodeUTF8)])
    @bBack.text = Qt::Application.translate("LeaderboardWindow", "Back", nil, Qt::Application::UnicodeUTF8)
    @bSearch.text = Qt::Application.translate("LeaderboardWindow", "Search", nil, Qt::Application::UnicodeUTF8)
    @bSort.text = Qt::Application.translate("LeaderboardWindow", "Sort", nil, Qt::Application::UnicodeUTF8)
  end # retranslateUi


end
