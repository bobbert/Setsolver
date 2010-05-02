class User < ActiveRecord::Base
  include FacebookerAuthentication::Model
  
  has_one :player

  after_create :new_player
  
  # create new Player object immediately after creating user
  def new_player
    self.player = Player.new
    save
  end

  def fb_user
    facebook_session.user
  end
  
end

