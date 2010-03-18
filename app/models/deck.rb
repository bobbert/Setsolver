class Deck < ActiveRecord::Base
  has_many :cards
  belongs_to :game

  after_create :reset

  # the deck length
  def all_dealt?
    facedown.empty?
  end

  # true if deck is empty
  def empty?
    cards.empty?
  end

  # get facedown deck
  def facedown
    cards.find_all {|c| c.facedown? }.sort
  end

  # get number of cards in facedown deck
  def faceup
    cards.find_all {|c| !(c.facedown?) }.sort
  end

  # gets all cards in game field
  def gamefield
    cards.find_all {|c| c.gamefield? }.sort
  end

  # get claimed deck; get only cards claimed by player_id if an integer is passed in
  def claimed(plyr_id = nil)
     cards.find_all {|c| c.claimed? && (plyr_id.nil? || (c.set.player == plyr_id.to_i)) }.sort
  end

  # return next faceup position in deck
  def next_faceup_position
    return 1 if (faceup == [])
    faceup.last.faceup_position + 1
  end
  
  # resets game deck with all fresh face-down cards
  def reset
    # delete all old cards, then reload deck
    cards.each {|c| Card.delete c }
    reload
    # create new cards
    Cardface.find(:all).each do |cf|
      c_new = Card.new :cardface_id => cf.id, :facedown_position => cf.id
      cards << c_new
      c_new.save
    end
    save
  end

  # randomizes order of face-down cards in deck
  def shuffle
    facedown_cards = cards.find_all {|c| c.facedown? }
    shuf_cards = facedown_cards.sort_by { rand }
    shuf_cards.each_with_index do |sc, i|
      # assigning ordering position manually.  This code pre-empts
      # acts_as_list for increased speed -- DO NOT reload Card objects!
      # (not reloading the objects is a feature here, not a bug.)
      sc.facedown_position = i + 1
      sc.save
    end
    save
  end

  # deals "number" number of cards from facedown to faceup list.
  # The cards are returned if saved successfuly, and number of
  # cards returned matches number requested.
  def deal(number = 1)
    faceup_init_pos = next_faceup_position
    cards_to_deal = facedown.slice(0, number)
    cards_to_deal.each_with_index do |c, i|
      c.facedown_position = nil
      c.faceup_position = faceup_init_pos + i
      return false unless c.save
    end
  end

end
