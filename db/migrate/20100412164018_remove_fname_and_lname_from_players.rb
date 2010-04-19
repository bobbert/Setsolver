class RemoveFnameAndLnameFromPlayers < ActiveRecord::Migration
  def self.up
    remove_column :players, :fname
    remove_column :players, :lname
  end

  def self.down
  end
end
