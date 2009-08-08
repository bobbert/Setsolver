class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :fname, :limit => 60
      t.string :lname, :limit => 60
      t.integer :rating, :default => 1000
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
