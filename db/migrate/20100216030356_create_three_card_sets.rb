class CreateThreeCardSets < ActiveRecord::Migration
  def self.up
    create_table :threecardsets do |t|
      t.integer :player_id
      t.integer :seconds_to_find
      t.timestamps
    end
  end

  def self.down
    drop_table :threecardsets
  end
end
