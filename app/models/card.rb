class Card < ActiveRecord::Base
  belongs_to :cardface
  belongs_to :deck
  belongs_to :threecardset

  validate :must_have_one_position_attribute

  # validation conditions: must have faceup or facedown position, but not both
  def must_have_one_position_attribute
    unless (facedown_position.blank? ^ faceup_position.blank?)
      errors.add_to_base("Card ##{self.id} has ambiguous position: " + 
                         "facedown_pos=#{(facedown_position || '<empty>').to_s}; " + 
                         "faceup_pos=#{(faceup_position || '<empty>').to_s}.!")
    end
  end

  # the abbreviated name of the card
  def abbrev
    cardface.abbrev
  end

  # image name, used to show picture
  def img_name
    cardface.img_name
  end

  # image name, used to show picture
  def img_path
    cardface.img_path
  end

  # image name, used to show picture
  def small_img_path
    cardface.small_img_path
  end

  # card name -- identical to human-readable name (to_s)
  def name
    cardface.to_s
  end

  # position within facedown or faceup list
  def position
    facedown_position || faceup_position
  end

  # human-readable name of card
  def to_s
    cardface.to_s
  end

  # is card face down in deck?
  def facedown?
    facedown_position && !(faceup_position)
  end

  # is card face up in deck?
  def faceup?
    faceup_position && !(facedown_position)
  end

  # is card claimed?
  def claimed?
    faceup? && !(threecardset.blank?)
  end

  # is card in the field of play?
  def gamefield?
    faceup? && threecardset.blank?
  end

  # player who claimed card as part of a Set
  def claimed_by
    threecardset.player if claimed?
  end

  # comparison operator - evaluates in the following order of precedence:
  # 1. facedown cards first, then faceup
  # 2. compare positions if facing is the same
  def <=>(other)
    if (self.facedown? ^ other.facedown?)
      return (self.facedown? ? 1 : -1)  # facedown sorted first
    else
      #both facedown or faceup: just compare positions
       pos = (self.position.to_i <=> other.position.to_i)
       return pos unless pos == 0
    end
    self.id <=> other.id
  end

end
