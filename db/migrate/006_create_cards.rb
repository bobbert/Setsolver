class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.integer :cardface_id
      t.integer :deck_id
      t.integer :facedown_position
      t.integer :faceup_position
      t.integer :claimed_by
    end

   # adding database index for referential integrity
    add_index "cards", ["cardface_id"], :name => "cardface_card_id_fkey"
  end

  def self.down
    remove_index "cards", :name => "cardface_card_id_fkey"
    drop_table :cards
  end
end
