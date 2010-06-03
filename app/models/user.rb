class User < ActiveRecord::Base
  unless RAILS_ENV == 'test'
    include FacebookerAuthentication::Model
  end

  has_one :player

  before_create :copy_fields_from_facebook
  after_create :new_player
  
  # create new Player object immediately after creating user
  def new_player
    self.player = Player.new
  end

  def fb_user
    facebook_session.user if facebook_session
  end

  def wall_header_for_last_finished_game
    "#{first_name} is now #{player.readable_skill_level(:article => true)}!"
  end

  def wall_post_for_last_finished_game
    "#{first_name} has a new best time: #{player.last_finished_game.selection_count} sets were found in " + 
    "in #{player.last_finished_game.total_time} seconds."
  end

protected

  # updating all Facebooker::User fields to internal values
  def copy_fields_from_facebook
    unless RAILS_ENV == 'test'
      Facebooker::User.user_fields.split(',').each do |field|
	self.send((field + '='), fb_user.send(field))
      end
      save
    end
  end

end

