class AddPhotoColumns < ActiveRecord::Migration
  def self.up
    add_column "photos", "created_at", :datetime
    add_column "photos", "thumbnail", :string
    add_column "photos", "description", :string
    Photo.find(:all).each do |p|
      p.update_attribute :created_at, Time.now
      p.update_attribute :thumbnail, p.filename.sub('.','_m.')
    end
  end

  def self.down
    remove_column "photos", "created_at"
    remove_column "photos", "thumbnail"
    remove_column "photos", "description"
  end
end
