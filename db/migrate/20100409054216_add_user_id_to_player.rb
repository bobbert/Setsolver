class AddUserIdToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :user_id, :integer
    # adding database indexes for referential integrity
    add_index "players", ["user_id"], :name => "player_user_id_fkey"
  end

  def self.down
   # removing database indexes
    remove_index "players", :name => "player_user_id_fkey"
    remove_column :players, :user_id
  end
end
