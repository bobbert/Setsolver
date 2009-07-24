class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :deck_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
