class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column "deck_count", :integer, :default => 0
      t.timestamps
    end
    # creating cards <-> games many to many association table
    create_table("cards_games", :id => false) do |t|
      t.column "card_id", :integer
      t.column "game_id", :integer
    end
  end

  def self.down
    drop_table :games
    drop_table :cards_games
  end
end
