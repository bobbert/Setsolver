class CreateCardDefaultRecords < ActiveRecord::Migration
  def self.up
    # assigning default values: every ID combination with tables
    # Number, Color, Shading, and Shape is added to table Card.
    Number.find(:all).each do |num|
      Color.find(:all).each do |col|
        Shading.find(:all).each do |shd|
          Shape.find(:all).each do |shp|
            c = Card.new
            c.number_id = num.id
            c.color_id = col.id
            c.shading_id = shd.id
            c.shape_id = shp.id
            c.save
          end
        end
      end
    end
  end

  def self.down
  end
end
