class Deck < ActiveRecord::Base
  has_many :cards, :order => "facedown_position"
  belongs_to :game

  # Returns an array of randomly selected Card objects, length "numcards".
  # The Card objects returned by this method are not removed from the deck.
  def get_random_cards( numcards = 1 )
    dealt = []
    return cards.to_a if numcards.to_i >= cards.length
    id_list = cards.map {|c| c.id }
    numcards.to_i.downto(1) do |num|
      rnd = rand id_list.length
      dealt << Card.find( id_list.slice!(rnd.floor) )
    end
    dealt
  end

  # deals "number" number of cards from facedown to faceup list.
  # The cards are returned if successful.
  def deal(number = 1)
    to_be_dealt = cards.find_all do |c|
      c.facedown_position && c.facedown_position <= number
    end
    num_prev_in_play = in_play.length
    # removing from facedown to faceup list, one card per iteration
    to_be_dealt.sort.each_with_index do |tbd_c, tbd_i|
      tbd_c.reload
      tbd_c.remove_from_list
      tbd_c.faceup_position = num_prev_in_play + tbd_i + 1
      tbd_c.save
    end
    save
  end

  # fills in-play game field with passed in number of cards
  def fill_game_field(number = Game::FIELD_SIZE)
    num_in_play = in_play.length
    return false if num_in_play > number
    deal (number - num_in_play)
  end

  # the deck length
  def length
    cards.length
  end

  # true if deck is empty
  def empty?
    cards.empty?
  end

  # get facedown deck
  def facedown
    cards.find_all {|c| c.facedown? }.sort
  end

  # gets all cards in game field
  def in_play
    cards.find_all {|c| c.in_play? }.sort
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

end
