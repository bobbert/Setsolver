class Game < ActiveRecord::Base
  has_one :deck
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

  #MAX_LISTEN_INTERVAL_SECONDS = 10
  #POLL_INTERVAL_SECONDS = 0.5

  #def self.num_polls
  #  (MAX_LISTEN_INTERVAL_SECONDS / POLL_INTERVAL_SECONDS).to_i
  #end
  

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
    self.deck = Deck.new
    save && deck.shuffle
  end

  # start playing the game
  def start
    return false if started?
    self.started_at = Time.now
    self.last_played_at = Time.now
    self.save
  end

  # get current gamefield
  def field
    deck.gamefield
  end
  
  def status
    return 'active' if active?
    return 'finished' if finished?
    return 'waiting'
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

  # fills gamefield so that it contains at least 1 set, then return array of sets.
  # Returns an empty array if no sets are found and the deck is empty (i.e. game finished)
  def fill_gamefield_with_sets
    deck.deal( (FIELD_SIZE - field.length) ) if field.length < FIELD_SIZE
    until ((tmp_sets = find_sets).length > 0)  # assigning to temp variable "tmp_sets"
      return [] if deck.all_dealt?
      deck.deal 3
    end
    tmp_sets
  end

  # returns an array-of-arrays where the inner array are matching sets of three Card objects,
  # or an empty array if no sets are found.
  def find_sets
    found_sets = []
    field_l = field
    Game.each_cmb3(field_l.length).each do |arr3|
      cards = arr3.map {|i| field_l[i] }
      found_sets << cards if is_set?(*cards)
    end
    found_sets
  end

  # the set-finding algorithm: given three card positions (within face-up array),
  # get the cardfaces and then iterate through each attribute (color, shading,
  # shape, number) and removes all instances where only a match of 2 exists -- 
  # because a match of 2 means "not all the same, and not all different."
  def is_set?( card1, card2, card3 )
    cardfaces = [card1.cardface, card2.cardface, card3.cardface]
    Cardface::ATTR.each do |attr|
      return false if num_different_attr( attr, cardfaces ) == 2
    end
    true
  end

  # evaluates player submission, and if set is valid:
  # set all three cards as claimed by player passed in, then
  # return the three-card set.
  def make_set_selection( plyr, *cards )
    return false unless is_set? *cards
    # increment score
    player_score = Score.find_by_player_id_and_game_id( plyr.id, self.id ).increment
    # create new set
    newset = Threecardset.new :cards => cards, :player => plyr
    newset if newset.save
  end

  # given an array of cardfaces and an attribute, finds out how many distinct
  # attribute types exist in the array for the attribute type passed in.
  def num_different_attr( attr, cardface_arr )
    res = cardface_arr.map {|c| c.send(attr) }
    res.uniq.length
  end

end
