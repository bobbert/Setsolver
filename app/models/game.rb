class Game < ActiveRecord::Base
  has_many :decks
  has_and_belongs_to_many :players

  after_create :new_deck

  FIELD_SIZE = 12
  VIEW_COLS = 6

  CARD_WIDTH = 80
  CARD_HEIGHT = 120

  BOARD_CELL_WIDTH  = (CARD_WIDTH * 1.2).floor
  BOARD_CELL_HEIGHT = (CARD_HEIGHT * 1.2).floor
  BOARD_TABLE_WIDTH = BOARD_CELL_WIDTH * VIEW_COLS


  # each_cmb3 (Class method)
  # performs a ( len 3 ) statistical combination, where len is the length of the
  # in-play deck.  The combination is returned as an array-of-arrays, where the inner
  # arrays are composed of 3 SORTED integers and the outer array has
  # (len)! / ((len-3)! * 3!) elements -- which gets big very quickly for large "len" values.
  def self.each_cmb3( cmb_len )
    retval = []
    # outermost loop: i = iterate from 0 to (len-1), add i to end of all arrays
    # middle loop: j = iterate from (i+1) to (len-1), add j to middle of arrays
    # inner loop: create array with numbers (j+1) to (len-1), which may be empty.
    0.upto(cmb_len - 1) do |i|
      (i+1).upto(cmb_len - 1) do |j|
        k_arr = ((j+1)..(cmb_len - 1)).to_a
        retval += k_arr.map {|k| [i,j,k] }
      end
    end
    retval
  end

  # create new deck with full set of cards, and shuffle cards
  # if auto-shuffle parameter is set
  def new_deck
    d = Deck.new
    decks << d
    d.save
    initialize_deck d
  end

  # get current deck in play
  def current_deck
    decks.find_all {|c| c.finished_at.nil? }.pop
  end

  # fills game field, or creates new deck if game field and deck are
  # unfilled and not valid.
  def refresh_game_field
    retval = fill_game_field
    retval = new_deck unless retval
    retval
  end

  # is game field valid for playing? -- meaning that the game field must be
  # fully dealt out and at least 1 set exists in the active field.
  def valid_game_field?
    d = current_deck
    num_cards_correct = (d.number_in_play >= FIELD_SIZE) || d.all_dealt?
    return num_cards_correct && (set_count > 0)
  end

  # get number of sets in current game field
  def set_count
    set_indices.length
  end

  # the set-finding algorithm: finds every statistical combination of 3 cards
  # (by array index), then iterates through the array once for
  # each attribute (color, shading, etc.) and removes all instances where
  # only a match of 2 exists -- because a maatch of 2 means "not all the same,
  # and not all different."
  def set_indices
    field = current_deck.in_play
    cmb3_arr = Game.each_cmb3 field.length
    Cardface::ATTR.each do |asp|
      cmb3_arr.delete_if do |arr3|
        num_different_attr( asp, arr3.map {|num| field[num].cardface } ) == 2
      end
    end
    cmb3_arr
  end

  # evaluates player submission, and if set is valid:
  # set all three cards as claimed by player passed in, then
  # return the three-card set.
  def make_set_selection( plyr_id, card1_i, card2_i, card3_i )
    si = set_indices
    return false unless si.include? [card1_i, card2_i, card3_i].sort
    # we have a valid set - get cards and set claimed_by, then return cards
    get_cards_in_play_from_index( card1_i, card2_i, card3_i ).each do |c|
      c.claimed_by = plyr_id
      c.save
    end
  end


private

  # fills in-play game field with passed in number of cards
  # Returns True if field is playable.
  def fill_game_field( number = FIELD_SIZE )
    num_to_fill = number - current_deck.in_play.length
    return false unless current_deck.deal num_to_fill
    until valid_game_field? do
      return false unless current_deck.deal 3
    end
    true
  end


  # initializing deck passed in with fresh cards, and shuffling if
  # autoshuffle is set. Returns true if successful
  def initialize_deck( d )
    retval = d.reset
    retval = d.shuffle if (autoshuffle && retval)
    retval
  end

  # given an array of cardfaces and an attribute, finds out how many distinct
  # attribute types exist in the array for the attribute type passed in.
  def num_different_attr( attr, cardface_arr )
    res = cardface_arr.map {|c| c.send(attr) }
    res.uniq.length
  end

  # converts in-play indices (such as those passed in as HTML form params)
  # into card objects based on position in list
  def get_cards_in_play_from_index( *indices )
    active_field = current_deck.in_play
    indices.map {|i| active_field[i.to_i] }
  end

end
