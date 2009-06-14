class CreateShadings < ActiveRecord::Migration
  ATTRIB = { 'outlined' => 'out', 'shaded' => 'shd', 'filled' => 'fil' }
  def self.up
    create_table :shadings do |t|
      t.column "name", :string, :limit => 30
      t.column "abbrev", :string, :limit => 3
    end
    # assigning default values
    ATTRIB.keys.sort.each do |nm|
      s = Shading.new
      s.name = nm
      s.abbrev = ATTRIB[nm]
      s.save
    end
  end

  def self.down
    drop_table :shadings
  end
end
