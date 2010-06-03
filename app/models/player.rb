class Player < ActiveRecord::Base
  has_many :scores
  has_many :threecardsets
  belongs_to :user
  belongs_to :skill_level

  # gets full name, as string
  def name
    user.name
  end

  # skill level
  def readable_skill_level(opts = {})
    is_article = (opts && opts[:article]) || false
    article = ((("AEIOU".include? skill_level.name[0]) ? 'an ' : 'a ') if is_article).to_s
    return article + skill_level.name + ' Setsolver' if skill_level
    article + 'a new player'
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

  # does at least one active game exist?
  def has_games_waiting_to_start?
    games_waiting_to_start.length > 0
  end

  def games_waiting_to_start
    games.select {|g| g.waiting_to_start? }
  end

  # does at least one active game exist?
  def has_active_games?
    active_games.length > 0
  end

  # get all games played by this player
  def active_games
    games.select {|g| g.active? }
  end

  # does at least one archived game exist?
  def has_archived_games?
    archived_games.length > 0
  end

  # get all games completed by this player
  def archived_games
    games.select {|g| g.finished? }
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

  # returns last game completely finished
  def last_finished_game
    archived_games.sort_by {|g| g.finished_at }.last
  end

  # will this player promote skill levels?
  def promote?
    return false if last_finished_game.blank?
    avg_time = last_finished_game.average_time
    return !(SkillLevel.highest_skill_level(avg_time).blank?) unless skill_level
    skill_level.promote? avg_time
  end

  # promote character to next skill level, if applicable.  Returns True if successful.
  def promote_to_next_level
    return false unless promote?
    self.skill_level = SkillLevel.highest_skill_level(last_finished_game.average_time)
    save
  end

end
