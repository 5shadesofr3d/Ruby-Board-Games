require 'sqlite3'
require 'test/unit'
require 'model'

class SavedGames
  def initialize
    @db = SQLite3::Database.new "saved_game.db"
    create_games unless games_exist?

    #post
    assert @db.is_a? SQLite3::Database
    assert games_exist?
    assert @games.each{|g| assert g.is_a? GameData}
  end

  #Returns true if the tables for DB exist already, false otherwise
  def games_exist?
    @db.execute "SELECT name FROM sqlite_master WHERE type='table' AND name='SavedGames'" do |res|
      return true
    end
    return false
  end

  #returns true if player exists in leaderboard table, false otherwise
  def game_exists?(name)
    #pre
    assert games_exist?

    @db.execute"SELECT * FROM SavedGames WHERE name='"+name+"'" do |res|
      return true
    end
    return false
  end

  #creates the necessary game data for saving a local game
  def create_games
    #pre
    assert games_exist? == false

    @db.execute "CREATE TABLE SavedGames (
    name varchar(64),
    players int,
    jsonString varchar(100000)
    );"

    #post
    assert games_exist?
  end

  #inserts new game to DB, and to gameData array
  def saveGame(name, players, game)
    #pre
    assert game.is_a? Game::Model::Abstract
    assert @db.is_a? SQLite3::Database

    jsonString = game.to_json

    if game_exists?(name)
      @db.execute("UPDATE SavedGames SET jsonString='"+jsonString+"' WHERE name='"+name+"'")
    else
      @db.execute("INSERT INTO SavedGames VALUES ('"+name+"', '"+players+"', '"+jsonString+"'")
    end

    #post
    assert game_exist?(game)
    assert @games.each{|g| assert g.is_a? GameData}
  end

  def loadGame(name)
    #pre
    assert name.is_a? String
    assert @db.is_a? SQLite3::Database

    games = get_games
    for game in games
      if game[0] == name
        return Game::Model::Abstract.from_json(game[2])
      end
    end

  end

  #gets all games
  def get_games
    #pre
    assert @db.is_a? SQLite3::Database

    games = []
    @db.execute( "SELECT name, players, jsonString" ) do |row|
      games << [row[0],row[1],row[2]]
    end

    #post
    assert games.is_a? Array
    games.each{|p| assert p.is_a? GameData}
    return games
  end


  def debug_print_data
    @db.execute( "SELECT * FROM game" ) do |row|
      p row
    end
  end
end