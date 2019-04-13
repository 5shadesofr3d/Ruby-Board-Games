require 'sqlite3'
require 'test/unit'

class SQLController
  include Test::Unit::Assertions

  def initialize
    @db = SQLite3::Database.new "boardgames.db"
    create_tables unless tables_exist?

    #post
    assert @db.is_a? SQLite3::Database
    assert tables_exist?
  end

  #Returns true if the tables for DB exist already, false otherwise
  def tables_exist?
    @db.execute "SELECT name FROM sqlite_master WHERE type='table' AND name='leaderboard'" do |res|
      return true
    end
    return false
  end

  #returns true if player exists in leaderboard table, false otherwise
  def player_exist?(name)
    #pre
    assert tables_exist?

    @db.execute"SELECT * FROM leaderboard WHERE name='"+name+"'" do |res|
      return true
    end
    return false
  end

  #creates the necessary tables for game DB
  def create_tables
    #pre
    assert tables_exist? == false

    @db.execute "CREATE TABLE leaderboard (
    name varchar(64),
    wins int,
    losses int,
    ties int
    );"

    #post
    assert tables_exist?
  end

  #inserts new player to DB
  def insert_new_player(name)
    #pre
    assert name.is_a? String
    assert @db.is_a? SQLite3::Database

    unless player_exist?(name)
      @db.execute("INSERT INTO leaderboard (name, wins, losses, ties)
      VALUES (?, ?, ?, ?)", [name, 0, 0, 0])
    end

    #post
    assert player_exist?(name)
  end

  #gets all players w/ wins, losses, ties
  def get_leaderboard
    #pre
    assert @db.is_a? SQLite3::Database

    players = []
    @db.execute( "SELECT name,wins,losses,ties FROM leaderboard" ) do |row|
      players << PlayerData.new(row[0],row[1],row[2],row[3])
    end

    #post
    assert players.is_a? Array
    players.each{|p| assert p.is_a? PlayerData}
    return players
  end

  #increments a players wins OR losses OR ties by 1
  def update_player(name,stat="wins")
    #pre
    assert @db.is_a? SQLite3::Database
    assert name.is_a? String
    assert stat.is_a? String
    assert ["wins","losses","ties"].include? stat
    assert player_exist?(name)

    @db.execute("UPDATE leaderboard SET "+stat+" = "+stat+" + 1 WHERE name='"+name+"'")
  end

  def debug_print_data
    @db.execute( "SELECT * FROM leaderboard" ) do |row|
      p row
    end
  end
end

class PlayerData
  include Test::Unit::Assertions

  attr_reader :name, :wins, :losses, :ties

  def initialize(name,wins,losses,ties)
    #pre
    assert name.is_a? String
    assert wins.is_a? Numeric
    assert losses.is_a? Numeric
    assert ties.is_a? Numeric

    @name = name
    @wins = wins
    @losses = losses
    @ties = ties

    assert @name.is_a? String
    assert @wins.is_a? Numeric
    assert @losses.is_a? Numeric
    assert @ties.is_a? Numeric
  end

end

# # EXAMPLE USAGE #####
# sql = SQLController.new
# sql.insert_new_player("gregg") ##Creates new player with 0 for all stats
# sql.insert_new_player("steve")
# sql.update_player("gregg") ##UPDATE DEFAULTS TO WINS
# sql.update_player("steve","losses")
# sql.update_player("steve","ties")
# sql.debug_print_data
# puts sql.get_leaderboard
# ######################
