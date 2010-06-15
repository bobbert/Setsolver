class Cardface < ActiveRecord::Base
  has_many :cards

  ATTR = [:number, :shading, :color, :shape]

  def self.get_random_card_image
    num = rand Cardface.find(:all).length
    Cardface.find(num).img_path
  end
  
  ExampleIds = [22,67,38,27]

  # a method that returns "examples" for the How To Play screen
  def self.example_cardfaces
    ExampleIds.map {|i| Cardface.find i }
  end

  # the abbreviated name of the card
  def abbrev
    number.to_s + shading_abbrev + color_abbrev + shape_abbrev
  end

  # image name, used to show picture
  def img_name
    abbrev + '.png'
  end

  # image name, used to show picture
  def img_path
    '/images/cards/' + img_name
  end

  # image name, used to show picture
  def small_img_path
    '/images/smallcards/' + img_name
  end


  # card name -- identical to human-readable name (to_s)
  def name
    to_s
  end

  # human-readable name of card
  def to_s
    printable_shape = (shape.singularize if number == 1) || shape.pluralize
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
