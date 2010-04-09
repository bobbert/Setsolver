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
  end

  def self.down
    drop_table :players
  end
end
