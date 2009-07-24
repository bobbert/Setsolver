class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.text    :name, :limit => 100
      t.integer :sets, :default => 0
      t.integer :wins, :default => 0
      t.integer :losses, :default => 0
      t.timestamps
    end

    # creating players <-> games many to many association table
    create_table("games_players", :id => false) do |t|
      t.integer "game_id"
      t.integer "player_id"
    end

    # adding database indexes for referential integrity
    add_index "games_players", ["game_id"], :name => "game_games_players_id_fkey"
    add_index "games_players", ["player_id"], :name => "player_games_players_id_fkey"
  end

  def self.down
   # removing database indexes for referential integrity
    remove_index "games_players", :name => "game_games_players_id_fkey"
    remove_index "games_players", :name => "player_games_players_id_fkey"
    # dropping association table, then data-record table
    drop_table :games_players
    drop_table :players
  end
end
