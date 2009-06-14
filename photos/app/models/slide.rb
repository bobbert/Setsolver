class Slide < ActiveRecord::Base
  belongs_to :slideshow
  acts_as_list :scope => "slideshow_id"
  belongs_to :photo
end
