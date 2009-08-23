class Score < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  validates_presence_of :game, :player

  # is this player in the lead? (ties don't count)
  def winner?
    higher_or_same_score_plyrs = game.scores.find_all {|sc| (sc != self) && sc.points >= self.points }
    higher_or_same_score_plyrs.empty?
  end

  # does this player have someone else beating them?
  # (NOTE: if player is tied for the lead, winner? and loser? are both false)
  def loser?
    higher_score_plyrs = game.scores.find_all {|sc| sc.points > self.points }
    !(higher_score_plyrs.empty?)
  end

  # comparison operator - orders by game first, then players within game.
  # Finally orders by ID, but this is only a sanity check (should not happen).
  def <=>(other)
    cmp = (self.game_id <=> other.game_id)
    cmp = (self.player_id <=> other.player_id) if cmp == 0
    cmp = (self.id <=> other.id) if cmp == 0
    cmp
  end

end
