class CreateColors < ActiveRecord::Migration
  ATTRIB = { 'red' => 'red', 'green' => 'grn', 'purple' => 'prp' }
  def self.up
    create_table :colors do |t|
      t.column "name", :string, :limit => 30
      t.column "abbrev", :string, :limit => 3
    end
    # assigning default values
    ATTRIB.keys.sort.each do |nm|
      c = Color.new
      c.name = nm
      c.abbrev = ATTRIB[nm]
      c.save
    end
  end

  def self.down
    drop_table :colors
  end
end
