class Player < ActiveRecord::Base
  has_many :scores
  has_many :threecardsets
  belongs_to :user

  # gets full name, as string
  def name
    user.fb_user.name
  end

  # returns player name as an identifier
  def name_as_identifier
    id.to_s + '_' + name.downcase.gsub(/\s/,'_')
  end
  
  # return player number, starting with player #1
  def number( gm )
    num = nil
    gm.players.each_with_index{|pl, i| num = i if (pl == self) }
    (num + 1) if num.is_a? Integer
  end

  # get all games played by this player
  def games
    scores.sort.map {|sc| sc.game }
  end

  # return Score corresponding to game passed in
  def score( gm )
    scores.select {|sc| sc.game == gm }.first
  end

  # get all games played by this player
  def active_games
    scores.map {|sc| sc.game }.select {|g| g.active? }
  end

  # get all games completed by this player
  def archived_games
    scores.map {|sc| sc.game }.select {|g| g.finished? }
  end

  # evaluates player submission, and if set is valid:
  # set all three cards as claimed by player passed in, then
  # return the three-card set.
  def make_set_selection( current_game, card1_i, card2_i, card3_i )
    return false unless current_game.is_set?( card1_i, card2_i, card3_i )
    # create new set
    newset = Threecardset.new 
    newset.cards << [card1_i, card2_i, card3_i].map {|i| Card.find_by_faceup_position i }
    self.threecardsets << newset
    newset.save
    # we have a valid set - increment score, then...
    player_score = Score.find_by_player_id_and_game_id( self.id, current_game.id ).increment
    newset
  end



end
