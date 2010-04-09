class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :points, :default => 0
      t.timestamps
    end
    # adding database indexes for referential integrity
    add_index "scores", ["player_id"], :name => "score_player_id_fkey"
    add_index "scores", ["game_id"], :name => "score_game_id_fkey"
  end

  def self.down
    # removing database indexes
    remove_index "scores", :name => "score_game_id_fkey"
    remove_index "scores", :name => "score_player_id_fkey"
    drop_table :scores
  end
end
