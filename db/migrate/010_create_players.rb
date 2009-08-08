class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :score, :default => 0
      t.timestamps
    end

    # adding database indexes for referential integrity
    add_index "players", ["user_id"], :name => "game_player_id_fkey"
    add_index "players", ["game_id"], :name => "user_player_id_fkey"
  end

  def self.down
   # removing database indexes
    remove_index "players", :name => "game_player_id_fkey"
    remove_index "players", :name => "user_player_id_fkey"
    # dropping association table, then data-record table.
    drop_table :players
  end
end
