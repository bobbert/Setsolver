class Game < ActiveRecord::Base
  has_one :deck
  has_many :cards, :order => "active_position"
  has_and_belongs_to_many :players

  FIELD_SIZE = 12
  VIEW_COLS = 6

  CARD_WIDTH = 80
  CARD_HEIGHT = 120

  BOARD_CELL_WIDTH  = (CARD_WIDTH * 1.2).floor
  BOARD_CELL_HEIGHT = (CARD_HEIGHT * 1.2).floor
  BOARD_TABLE_WIDTH = BOARD_CELL_WIDTH * VIEW_COLS

  # create new deck and shuffle if auto-shuffle parameter is set
  def new_deck(autoshuffle = true)
    ashuf = ('Y' if autoshuffle)
    deck = Deck.new autoshuffle => ashuf
    deck.reset
  end

  # fills in-play game field with passed in number of cards
  # Returns True if field is playable.
  def fill_game_field(number = FIELD_SIZE)
    num_in_play = deck.in_play.length
    return false unless deal (number - num_in_play)
    until valid_game_field?
      return false if deck.all_dealt?
      deck.deal 3
    end
    true
  end

  # is game field valid for playing? -- meaning that the game field must be
  # fully dealt out and at least 1 set exists in the active field.
  def valid_game_field?
    num_cards_correct = (deck.number_in_play >= FIELD_SIZE) || deck.all_dealt?
    return num_cards_correct && set_exists?
  end

  # returns true if the array of 3 numbers passed in is contained in
  # the array of sets returned by find_sets
  def is_set?( arr )
    true if set_indices.find{|a| a === arr }
  end

  # does at least 1 set exist in field?
  def set_exists?
    !(set_indices.empty?)
  end

  # the set-finding algorithm: finds every statistical combination of 3 cards,
  # then iterates through array once for each attribute (color, shading, etc.) and
  # removes all instances where only a match of 2 exists.
  def set_indices
    cmb3_arr = each_cmb3
    Card::ATTR.each do |asp|
      cmb3_arr.delete_if do |arr3|
        num_different_attr( asp, arr3.map {|num| cards[num] } ) == 2
      end
    end
    cmb3_arr
  end

  def sets
    cards_in_play = deck.in_play
    set_indices.map{|s_arr| s_arr.map {|s_idx| cards_in_play[s_idx] } }
  end

private

  # performs a ( len 3 ) statistical combination, where len is the length of the
  # in-play deck.  The combination is returned as an array-of-arrays, where the inner
  # arrays are of length 3 and the outer array is length ( len 3 ) with distinct elements.
  def each_cmb3
    num_in_play = deck.in_play.length
    retval = []
    # outermost loop: i = iterate from 0 to (len-1), add i to end of all arrays
    # middle loop: j = iterate from (i+1) to (len-1), add j to middle of arrays
    # inner loop: create array with numbers (j+1) to (len-1), which may be empty.
    0.upto(num_in_play - 1) do |i|
      (i+1).upto(num_in_play - 1) do |j|
        k_arr = ((j+1)..(num_in_play - 1)).to_a
        retval += k_arr.map {|k| [i,j,k] }
      end
    end
    retval
  end

  # given an array of cards and an attribute, finds out how many distinct
  # attribute types exist in the array for the attribute type passed in.
  def num_different_attr(asp, card_arr)
    res = card_arr.map {|c| c.send(asp) }
    res.uniq.length
  end

end
