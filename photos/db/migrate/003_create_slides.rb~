class CreateSlides < ActiveRecord::Migration
  def self.up
    create_table "slides" do |t|
      t.column "position", :integer
      t.column "photo_id", :integer
      t.column "slideshow_id", :integer
    end
  end

  def self.down
    drop_table "slides"
  end
end
