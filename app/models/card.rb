class Card < ActiveRecord::Base
  belongs_to :color
  belongs_to :number
  belongs_to :shading
  belongs_to :shape
  has_and_belongs_to_many :games
  has_and_belongs_to_many :decks
  validates_presence_of :color, :number, :shading, :shape

  ATTR = [:number, :shading, :color, :shape]

  # the abbreviated name of the card
  def abbrev
    number.abbrev + shading.abbrev + color.abbrev + shape.abbrev
  end

  # image name, used to show picture
  def img_name
    abbrev + '.png'
  end

  # card name -- identical to human-readable name (to_s)
  def name
    to_s
  end

  # human-readable name of card
  def to_s
    plural = 's' if (number.abbrev.to_i != 1)
    number.abbrev + ' ' + shading.name + ' ' + color.name + ' ' + shape.name + plural.to_s
  end

  # comparison operator - used for card array ordering, or sorting by ID
  def <=>(other)
    self.id <=> other.id
  end

  # equality operator - are two cards equal?
  def ==(other)
    self.id == other.id
  end

end
