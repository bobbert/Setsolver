class Photo < ActiveRecord::Base
  validates_presence_of :filename
  has_many :slides
  has_and_belongs_to_many :categories
end
