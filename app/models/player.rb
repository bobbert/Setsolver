class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  # full name of user
  def name
    user.name
  end

  # return player number
  def number
    num = 0
    game.players.sort.each_with_index{|pl, i| num = i if (pl == self) }
    (num + 1)
  end

  # is this player in the lead? (ties don't count)
  def winner?
    higher_or_same_score_plyrs = game.players.find_all {|pl| (pl != self) && pl.score >= self.score }
    higher_or_same_score_plyrs.empty?
  end

  # does this player have someone else beating them?
  # (NOTE: if player is tied for the lead, winner? and loser? are both false)
  def loser?
    higher_score_plyrs = game.players.find_all {|pl| pl.score > self.score }
    !(higher_score_plyrs.empty?)
  end

  # evaluates player submission, and if set is valid:
  # set all three cards as claimed by player passed in, then
  # return the three-card set.
  def make_set_selection( card1_i, card2_i, card3_i )
    si = game.set_indices
    return false unless si.include? [card1_i, card2_i, card3_i].sort
    # we have a valid set - get cards and set claimed_by, then return cards
    score += 1
    game.get_cards_in_play_from_index( card1_i, card2_i, card3_i ).each do |c|
      c.claimed_by = self
      c.save
    end
  end

  # comparison operator - orders by time of creation
  def <=>(other)
    self.created_at <=> other.created_at
  end


end
