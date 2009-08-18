class Cardface < ActiveRecord::Base
  has_many :cards

  ATTR = [:number, :shading, :color, :shape]

  # the abbreviated name of the card
  def abbrev
    number.to_s + shading_abbrev + color_abbrev + shape_abbrev
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
    printable_shape = ((number != 1) ? shape.pluralize : shape.singularize)
    number.to_s + ' ' + shading + ' ' + color + ' ' + printable_shape
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
