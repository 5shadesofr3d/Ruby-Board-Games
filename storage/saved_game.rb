require 'sqlite3'
require 'test/unit'

class SavedGame
  def initialize
    @db = SQLite3::Database.new "saved_game.db"
    create_games unless games_exist?
    @games = get_games

    #post
    assert @db.is_a? SQLite3::Database
    assert games_exist?
    assert @games.each{|g| assert g.is_a? GameData}
  end

  #Returns true if the tables for DB exist already, false otherwise
  def games_exist?
    @db.execute "SELECT name FROM sqlite_master WHERE type='table' AND name='game'" do |res|
      return true
    end
    return false
  end

  #returns true if player exists in leaderboard table, false otherwise
  def game_exists?(name)
    #pre
    assert games_exist?

    @db.execute"SELECT * FROM game WHERE name='"+name+"'" do |res|
      return true
    end
    return false
  end

  #creates the necessary game data for saving a local game
  def create_games
    #pre
    assert games_exist? == false

    @db.execute "CREATE TABLE game (
    name varchar(64),
    players int,
    rows int,
    columns int,
    height int,
    width int,
    type varchar(64),
    colors varchar(64)
    turn int
    chips varchar(256)
    );"

    #post
    assert games_exist?
  end

  #inserts new game to DB, and to gameData array
  def addGame(game)
    #pre
    assert game.is_a? Game
    assert @db.is_a? SQLite3::Database

    # Insert code that adds the game game and all its properties (which will be handled with getters in game) to the database

    #post
    assert game_exist?(game)
    assert @games.each{|g| assert g.is_a? GameData}
  end

  #gets all games
  def get_games
    #pre
    assert @db.is_a? SQLite3::Database

    games = []
    @db.execute( "SELECT name,players,rows,columns,height,width,type,colors,turn,chips FROM game" ) do |row|
      players << GameData.new(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9])
    end

    #post
    assert games.is_a? Array
    games.each{|p| assert p.is_a? GameData}
    return games
  end

  #increments a players wins OR losses OR ties by 1
  def update_game(name, stat)
    #pre
    assert @db.is_a? SQLite3::Database
    assert name.is_a? String
    assert game.is_a? Game
    assert ["players, rows, columns, height, width, type, colors, turn, chips"].include? stat
    assert game_exists?(name)

    @db.execute("UPDATE game SET "+stat+" = "+stat+" + 1 WHERE name='"+name+"'")
  end

  def debug_print_data
    @db.execute( "SELECT * FROM game" ) do |row|
      p row
    end
  end
end

class GameData
  include Test::Unit::Assertions

  attr_reader :name, :players, :rows, :columns, :height, :width, :type, :colors, :turn, :chips

  def initialize(name, players, rows, columns, height, width, type, colors, turn, chips)
    #pre
    assert name.is_a? String
    assert players.is_a? Numeric
    assert rows.is_a? Numeric
    assert columns.is_a? Numeric
    assert height.is_a? Numeric
    assert width.is_a? Numeric
    assert type.is_a? String
    assert colors.is_a? String
    assert turn.is_a? String
    assert chips.is_a? String

    @name = name
    @players = players
    @rows = rows
    @columns = columns
    @height = height
    @width = width
    @type = type
    @colors = colors
    @turn = turn
    @chips = chips

    assert @name.is_a? String
    assert @players.is_a? Numeric
    assert @rows.is_a? Numeric
    assert @columns.is_a? Numeric
    assert @height.is_a? Numeric
    assert @width.is_a? Numeric
    assert @type.is_a? String
    assert @colors.is_a? String
    assert @turn.is_a? String
    assert @chips.is_a? String
  end

  def buildGame()
    assert @name.is_a? String
    assert @players.is_a? Numeric
    assert @rows.is_a? Numeric
    assert @columns.is_a? Numeric
    assert @height.is_a? Numeric
    assert @width.is_a? Numeric
    assert @type.is_a? String
    assert @colors.is_a? String
    assert @turn.is_a? String
    assert @chips.is_a? String

    #Build a game object based on the properties and return it

    assert game.is_a? Game
    return game

  end

end
