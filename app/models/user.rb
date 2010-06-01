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

  def wall_header_for_last_finished_game
    article = ("AEIOU".include? player.skill_level.name[0]) ? 'an' : 'a'
    "#{first_name} is now #{article} #{player.skill_level.name.downcase} Setsolver player!"
  end

  def wall_post_for_last_finished_game
    "#{first_name} has a new best time: #{player.last_finished_game.selection_count} sets were found in " + 
    "in #{player.last_finished_game.total_time} seconds."
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

