class Game < ActiveRecord::Base
  has_many :decks
  has_many :scores

  after_create :new_deck

  FIELD_SIZE = 12
  VIEW_COLS = 4

  CARD_WIDTH = 80
  CARD_HEIGHT = 120

  BOARD_CELL_WIDTH  = (CARD_WIDTH * 1.2).floor
  BOARD_CELL_HEIGHT = (CARD_HEIGHT * 1.2).floor
  BOARD_TABLE_WIDTH = BOARD_CELL_WIDTH * VIEW_COLS

  MAX_NUMBER_OF_PLAYERS = 4


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
    d.save && d.shuffle
  end

  # get current deck in play
  def current_deck
    decks.find_all {|c| c.finished_at.nil? }.pop
  end

  # get current gamefield
  def field
    current_deck.in_play
  end

  # get all games played by this player
  def players
    scores.sort.map {|sc| sc.player }
  end

  # has game been started?  Games musst have at least one player and a start date to be considered started.
  def started?
    !(started_at.nil? || players.length == 0)
  end

  # is game active?...i.e. started but not finished?
  def active?
    started? && !finished?
  end

  # has game been completed?
  def finished?
    !(finished_at.nil?)
  end
    
  # is this a multi-player game?
  def multiplayer?
    players.length > 1
  end

   # can players be added to this game?
  def can_add_player?
    players.length < MAX_NUMBER_OF_PLAYERS
  end

  # list of players that can be added
  def player_add_list
    Player.find(:all).delete_if {|p| players.include? p }
  end

  # adds player to new game -- returns player added if successful
  def add_player( new_player )
    return false unless can_add_player?
    sc = Score.new
    self.scores << sc
    new_player.scores << sc
  end

  # remove player from new game -- returns player if removed
  def remove_player( plyr )
    sc = Score.find_by_player_id_and_game_id( plyr.id, self.id )
    return false unless sc
    sc.player if sc.destroy
  end

  # get names of players
  def player_names
    players.map {|pl| pl.name }.join(' vs. ')
  end

  # fills gamefield, or creates new deck and fills gamefield with new deck 
  # if deck is empty.
  def refresh_field
    return true if fill_game_field 
    return (new_deck && fill_game_field)
  end

  # is game field valid for playing? -- meaning that the game field must be
  # fully dealt out and at least 1 set exists in the active field.
  def valid_game_field?( has_sets = nil )
    d = current_deck
    if has_sets.nil?
      has_sets = (set_count > 0)
    end
    num_cards_correct = (d.number_in_play >= FIELD_SIZE) || d.all_dealt?
    return num_cards_correct && has_sets
  end

  # get number of sets in current game field
  def set_count
    set_indices.length
  end

  # finds every statistical combination of 3 cards (by array index),
  # then deletes the non-set combinations.
  def set_indices
    cmb3_arr = Game.each_cmb3 field.length
    cmb3_arr.delete_if do |arr3|
      !(is_set? *arr3)
    end
  end

  # the set-finding algorithm: given three card positions (within face-up array),
  # get the cardfaces and then iterate through each attribute (color, shading,
  # shape, number) and removes all instances where only a match of 2 exists -- 
  # because a match of 2 means "not all the same, and not all different."
  def is_set?( card1_pos, card2_pos, card3_pos )
    cardfaces = [card1_pos, card2_pos, card3_pos].map {|num| field[num].cardface }
    Cardface::ATTR.each do |attr|
      return false if num_different_attr( attr, cardfaces ) == 2
    end
    true
  end

  # converts in-play indices (such as those passed in as HTML form params)
  # into card objects based on position in list
  def get_cards_in_play_from_index( *indices )
    active_field = field
    indices.map {|i| active_field[i.to_i] }
  end

private

  # fills in-play game field to size <number>.
  # Returns True if field is playable.
  def fill_game_field( number = FIELD_SIZE )
    num_to_fill = number - field.length
    return false unless current_deck.deal num_to_fill
    until valid_game_field? do
      dealt = current_deck.deal 3
      return false if (dealt == [])
    end
    true
  end

  # given an array of cardfaces and an attribute, finds out how many distinct
  # attribute types exist in the array for the attribute type passed in.
  def num_different_attr( attr, cardface_arr )
    res = cardface_arr.map {|c| c.send(attr) }
    res.uniq.length
  end

end
