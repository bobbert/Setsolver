class Card < ActiveRecord::Base
  belongs_to :cardface
  belongs_to :deck
  acts_as_list :scope => :deck, :column => :facedown_position


  # the abbreviated name of the card
  def abbrev
    cardface.abbrev
  end

  # image name, used to show picture
  def img_name
    cardface.img_name
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
    facedown_position && true
  end

  # is card in play?
  def in_play?
    facedown_position.nil? && faceup_position && claimed_by.nil?
  end

  # is card claimed?
  def claimed?
    facedown_position.nil? && faceup_position && claimed_by
  end

  # comparison operator - evaluates in the following order of precedence:
  # 1. facedown cards first, then faceup
  # 2. compare positions if facing is the same
  def <=>(other)
    if (self.facedown? ^ other.facedown?)
      return (self.facedown? ? 1 : -1)  # facedown sorted first
    else
      #both facedown or faceup: just compare positions
      return (self.position <=> other.position)
    end
    self.id <=> other.id
  end

end
