class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.column "number_id", :integer
      t.column "color_id", :integer
      t.column "shading_id", :integer
      t.column "shape_id", :integer
    end
  end

  def self.down
    drop_table :cards
  end
end
