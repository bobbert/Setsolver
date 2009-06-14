class CreateDecks < ActiveRecord::Migration
  def self.up
    create_table :decks do |t|
      t.column "game_id", :integer
      t.timestamps
    end
    # creating cards <-> decks many to many association table
    create_table("cards_decks", :id => false) do |t|
      t.column "card_id", :integer
      t.column "deck_id", :integer
    end
  end

  def self.down
    drop_table :decks
    drop_table :cards_decks
  end
end
