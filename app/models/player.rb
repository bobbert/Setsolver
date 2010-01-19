class Player < ActiveRecord::Base
  has_many :scores


  # gets full name, as string
  def name
    (fname.to_s + ' ' + lname.to_s).chomp ' '
  end

  # assigns full name, as string, and parses first and last names
  # from full name string.
  def name=( s_fullname )
    if ( (arr_name = s_fullname.split(', ')).length == 2 )
      (self.lname, self.fname) = arr_name
      return save
    end
    if ( (arr_name = s_fullname.split(' ')).length == 2 )
      (self.fname, self.lname) = arr_name
      return save
    end
    false
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
    # we have a valid set - increment score, then...
    player_score = Score.find_by_player_id_and_game_id( self.id, current_game.id )
    player_score.points = player_score.points.to_i + 1
    player_score.save
    # assign cards as claimed by player, then return cards
    current_game.get_cards_in_play_from_index( card1_i, card2_i, card3_i ).each do |c|
      c.claimed_by = self.id
      c.save
    end
  end



end
