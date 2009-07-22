class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.integer :cardface_id
      t.integer :deck_id
      t.integer :facedown_position
      t.integer :faceup_position
      t.integer :claimed_by
    end
  end

  def self.down
    drop_table :cards
  end
end
