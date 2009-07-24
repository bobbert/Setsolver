class CreateDecks < ActiveRecord::Migration
  def self.up
    create_table :decks do |t|
      t.integer :game_id
      t.text    :autoshuffle, :limit => 1
      t.timestamps
    end

   # adding database index to Cards for referential integrity
    add_index "cards", ["deck_id"], :name => "deck_card_id_fkey"
  end

  def self.down
    remove_index "cards", :name => "deck_card_id_fkey"
    drop_table :decks
  end
end
