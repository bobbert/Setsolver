class CreateCardfaces < ActiveRecord::Migration
  def self.up
    create_table :cardfaces do |t|
      t.integer :number_id
      t.integer :color_id
      t.integer :shading_id
      t.integer :shape_id
    end

    # adding database indexes for referential integrity
    add_index "cardfaces", ["number_id"], :name => "number_cardface_id_fkey"
    add_index "cardfaces", ["shading_id"], :name => "shading_cardface_id_fkey"
    add_index "cardfaces", ["color_id"], :name => "color_cardface_id_fkey"
    add_index "cardfaces", ["shape_id"], :name => "shape_cardface_id_fkey"

    # assigning default values for all cardfaces:
    # every ID combination with tables.
    # Number, Color, Shading, and Shape is added to table Cardface.
    Number.find(:all).each do |num|
      Color.find(:all).each do |col|
        Shading.find(:all).each do |shd|
          Shape.find(:all).each do |shp|
            c = Cardface.new
            c.number_id = num.id
            c.color_id = col.id
            c.shading_id = shd.id
            c.shape_id = shp.id
            c.save
          end
        end
      end
    end # finished inserting cardface data rows

  end

  def self.down
    # removing database indexes for referential integrity
    remove_index "cardfaces", :name => "number_cardface_id_fkey"
    remove_index "cardfaces", :name => "shading_cardface_id_fkey"
    remove_index "cardfaces", :name => "color_cardface_id_fkey"
    remove_index "cardfaces", :name => "shape_cardface_id_fkey"
    # dropping table after removing indexes
    drop_table :cardfaces
  end
end
