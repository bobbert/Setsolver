class Slideshow < ActiveRecord::Base
  has_many :slides, :order => :position
end
