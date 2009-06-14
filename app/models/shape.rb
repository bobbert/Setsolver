class Shape < ActiveRecord::Base
  has_many :card
  validates_uniqueness_of :name, :abbrev
  validates_presence_of :name, :abbrev
end
