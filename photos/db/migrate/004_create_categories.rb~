class CreateCategories < ActiveRecord::Migration
  def self.up
    # creating Categories table
    create_table "categories" do |t|
      t.column "name", :string
      t.column "parent_id", :integer
    end
    # creating Categories <-> Photos xref table, has no PK
    create_table ("categories_photos", :id => false) do |t|
      t.column "category_id", :integer
      t.column "photo_id", :integer
    end
    # placing all photos into default category
    Category.new do |c|
      c.name = "All"
      Photo.find(:all).each do |photo|
        photo.categories << c
        photo.save
      end
    end
  end

  def self.down
    drop_table "categories"
    drop_table "categories_photos"
  end
end
