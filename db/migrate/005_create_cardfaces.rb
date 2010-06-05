class CreateCardfaces < ActiveRecord::Migration

  NUMBERS = [1, 2, 3]
  COLORS = { 'red' => 'red', 'green' => 'grn', 'purple' => 'prp' }
  SHADINGS = { 'outlined' => 'out', 'shaded' => 'shd', 'filled' => 'fil' }
  SHAPES = { 'oval' => 'ovl', 'diamond' => 'dia', 'squiggle' => 'sqg' }

  def self.up
    create_table :cardfaces do |t|
      t.integer   :number
      t.string    :color,          :limit => 30
      t.string    :color_abbrev,   :limit => 3
      t.string    :shading,        :limit => 30
      t.string    :shading_abbrev, :limit => 3
      t.string    :shape,          :limit => 30
      t.string    :shape_abbrev,   :limit => 3
    end

    # seeding Cardface with initial values for each card type:
    # (Number, Color, Shading, and Shape) is added to table Cardface.
    NUMBERS.each do |num|
      COLORS.each do |col, col_abbrev|
        SHADINGS.each do |shd, shd_abbrev|
          SHAPES.each do |shp, shp_abbrev|
            c = Cardface.new
            c.number = num
            c.color = col
            c.color_abbrev = col_abbrev
            c.shading = shd
            c.shading_abbrev = shd_abbrev
            c.shape = shp
            c.shape_abbrev = shp_abbrev
            c.save
          end
        end
      end
    end # finished inserting cardface data rows

  end

  def self.down
    # dropping table after removing indexes
    drop_table :cardfaces
  end
end
