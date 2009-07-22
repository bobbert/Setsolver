class CreateCardfaces < ActiveRecord::Migration
  def self.up
    create_table :cardfaces do |t|
      t.integer :number_id
      t.integer :color_id
      t.integer :shading_id
      t.integer :shape_id
    end

    # assigning default values for all cardfaces:
    # every ID combination with tables
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
    end
    # end inserting cardface data rows
  end

  def self.down
    drop_table :cardfaces
  end
end
