class AddThreeCardSetIdToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :threecardset_id, :integer
    # adding database indexes for referential integrity
    add_index "cards", ["threecardset_id"], :name => "card_threecardset_id_fkey"
  end

  def self.down
   # removing database indexes
    remove_index "cards", :name => "card_threecardset_id_fkey"
    remove_column :cards, :threecardset_id
  end
end
