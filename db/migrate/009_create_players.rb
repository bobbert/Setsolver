class CreatePlayers < ActiveRecord::Migration
  def self.up
    # creating table for players
    create_table :players do |t|
      t.string  :fname,  :limit => 50
      t.string  :lname,  :limit => 50
      t.integer :wins,   :default => 0
      t.integer :losses, :default => 0
      t.integer :rating, :default => 1000
      t.timestamps
    end

    # creating intermediary table for scores; acts as many-to-many association
    # table except with one data field (points) included.
    create_table :scores do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :points, :default => 0
      t.timestamps
    end

    # adding database indexes for referential integrity
    add_index "scores", ["player_id"], :name => "score_player_id_fkey"
    add_index "scores", ["game_id"], :name => "score_game_id_fkey"
    add_index "cards",  ["claimed_by"], :name => "card_claimed_by_fkey"
  end

  def self.down
   # removing database indexes
    remove_index "scores", :name => "score_game_id_fkey"
    remove_index "scores", :name => "score_player_id_fkey"
    remove_index "cards",  :name => "card_claimed_by_fkey"
    # dropping intermediary table, then data-record table.
    drop_table :scores
    drop_table :players
  end
end
