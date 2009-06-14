class CreateSlideshows < ActiveRecord::Migration
  def self.up
    create_table "slideshows" do |t|
      t.column "name", :string
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table "slideshows"
  end
end
