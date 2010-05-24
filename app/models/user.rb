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
    update_fields 
  end

  def fb_user
    facebook_session.user if facebook_session
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

