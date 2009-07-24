class CreateNumbers < ActiveRecord::Migration
  ATTRIB = { 'one' => '1', 'two' => '2', 'three' => '3' }
  def self.up
    create_table :numbers do |t|
      t.text :name,   :limit => 30
      t.text :abbrev, :limit => 3
    end
    # assigning default values, sorted by value instead of by key
    ATTRIB.sort {|a,b| a[1] <=> b[1]}.each do |nm_arr|
      n = Number.new
      n.name = nm_arr[0]
      n.abbrev = nm_arr[1]
      n.save
    end
  end

  def self.down
    drop_table :numbers
  end
end
