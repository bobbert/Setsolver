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
      t.column "game_id", :integer
      t.column "player_id", :integer
    end
  end

  def self.down
    drop_table :players
    drop_table :games_players
  end
end
