class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer    :selection_count, :default => 0
      t.timestamps
      t.date       :started_at
      t.date       :finished_at
    end

   # adding database index to Decks for referential integrity
    add_index "decks", ["game_id"], :name => "game_deck_id_fkey"
  end

  def self.down
    remove_index "decks", :name => "game_deck_id_fkey"
    drop_table :games
  end
end
