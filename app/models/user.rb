class User < ActiveRecord::Base
  unless RAILS_ENV == 'test'
    include FacebookerAuthentication::Model
  end

  has_one :player

  after_create :new_player
  after_update :update_fields
  
  # create new Player object immediately after creating user
  def new_player
    self.player = Player.new
#    update_fields if save
  end

  def fb_user
    facebook_session.user if facebook_session
  end

  def last_finished_game
    player.archived_games.sort_by {|g| g.finished_at }.last
  end
  
  def wall_header_for_last_finished_game
    "#{first_name} has completed #{player.archived_games.length} Setsolver games!"
  end

  def wall_post_for_last_finished_game
    "In the latest game, #{first_name} found #{last_finished_game.selection_count} sets " + 
    "in #{last_finished_game.total_time} seconds."
  end

  protected

  # updating all Facebooker::User fields to internal values
  def update_fields
    unless RAILS_ENV == 'test'
      Facebooker::User.user_fields.split(',').each do |field|
	self.send((field + '='), fb_user.send(field))
      end
      save
    end
  end

end

