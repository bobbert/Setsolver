class Deck < ActiveRecord::Base
  has_many :cards, :order => "facedown_position"
  belongs_to :game

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
  def facedown_length
    cards.find_all {|c| c.facedown? }.length
  end

  # gets all cards in game field
  def in_play
    cards.find_all {|c| c.in_play? }.sort
  end

  # gets number of cards in game field
  def number_in_play
    cards.find_all {|c| c.in_play? }.length
  end

  # get claimed deck; get only cards claimed by player_id if an integer is passed in
  def claimed(plyr_id = nil)
    cards.find_all {|c| c.claimed? }.sort unless plyr_id
    cards.find_all {|c| c.claimed? && (c.claimed_by == plyr_id.to_i) }.sort
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
    to_be_dealt = cards.find_all do |c|
      c.facedown_position && c.facedown_position <= number
    end
    num_prev_in_play = in_play.length
    faceup_nums = next_faceup_positions to_be_dealt.length
    # removing from facedown to faceup list, one card per iteration
    to_be_dealt.sort!.each_with_index do |tbd_c, tbd_i|
      tbd_c.reload
      tbd_c.remove_from_list
      tbd_c.faceup_position = faceup_nums[tbd_i]
      tbd_c.save
    end
    save && reload
    to_be_dealt
  end

private

  # getting next numbers for faceup position, as array, by finding
  # unused numbers in faceup_position progression
  def next_faceup_positions( number = 1 )
    num_possible_ind = number_in_play + number
    # get existing faceup position numbers
    faceup_inds = in_play.map {|c| c.faceup_position }
    remaining = (1..num_possible_ind).to_a.delete_if do |i|
      faceup_inds.include? i
    end
    # return first <number> remaining numbers.
    return remaining.slice( 0, number )
  end

end
