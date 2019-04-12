# This is the leaderboard class that will be able to display the entire list of
# players who have made it to the leaderboard
require 'Qt'
require 'test/unit'
# require_relative '../GameData'
require_relative '../settings'
require_relative 'ldboardTableComp'

class LeaderboardState < Qt::Widget
  include Test::Unit::Assertions
  attr_accessor :window, :main_window

  def valid?
    return false unless @main_window.height > 0
    return false unless @main_window.width > 0
    return false unless @window.is_a? QTApplication
    return false unless @main_window.is_a? Qt::MainWindow
    return true
  end

  # Create GUI here.
  def initialize
    super

    @window = QTApplication.instance
    @main_window = Qt::MainWindow.new

    settings = Settings.instance
    @main_window.setFixedSize(settings.window_width, settings.window_height)
    @main_window.setWindowTitle("Ruby-Board-Games")

    @main_window.show#show title
    @leaderboard = Leaderboard.new(settings.window_width, settings.window_height, @main_window)

    assert @window.is_a? QTApplication
    assert @main_window.is_a? Qt::MainWindow
    assert @main_window.width > 0
    assert @main_window.height > 0
    assert @main_window.visible
    assert valid?
  end
end