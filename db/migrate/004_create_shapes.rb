class CreateShapes < ActiveRecord::Migration
  ATTRIB = { 'oval' => 'ovl', 'diamond' => 'dia', 'squiggle' => 'sqg' }
  def self.up
    create_table :shapes do |t|
      t.text :name,   :limit => 30
      t.text :abbrev, :limit => 3
    end
    # assigning default values
    ATTRIB.keys.sort.each do |nm|
      s = Shape.new
      s.name = nm
      s.abbrev = ATTRIB[nm]
      s.save
    end
  end

  def self.down
    drop_table :shapes
  end
end
