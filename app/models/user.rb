class User < ActiveRecord::Base
  unless RAILS_ENV == 'test'
    include FacebookerAuthentication::Model
  end

  has_one :player
  after_create :new_player
  
  # create new Player object immediately after creating user
  def new_player
    self.player = Player.new
#    copy_fields_from_facebook
  end

  def fb_user
    self.facebook_session.user if self.facebook_session
  end

  def wall_header_for_last_finished_game
    "#{first_name} is now #{player.readable_skill_level(:article => true)}!"
  end

  def wall_post_for_last_finished_game
    "#{first_name} has a new best time: #{player.last_finished_game.selection_count} sets were found in " + 
    "in #{player.last_finished_game.total_time} seconds."
  end

  SpecialFields = ['status','meeting_sex','hs_info','hometown_location','work_history',
                   'education_history','meeting_for','current_location','affiliations',
                   'family']

  # updating all Facebooker::User fields to internal values
  def copy_fields_from_facebook
    unless RAILS_ENV == 'test'
      Facebooker::User.user_fields.split(',').each do |field|
        field_assign_method = field + '='
        if self.respond_to?(field_assign_method)
	  self.send(field_assign_method, get_fb_field(field).to_s.slice(0,255))
	end
      end
      self.save!
    end
  end

protected

  def get_fb_field(field)
    return fb_user.send(field) unless SpecialFields.include?(field)
    # special fields: list cases here
    case field
    when 'status' 
      return fb_user.status.message if fb_user.status
    when 'meeting_sex', 'meeting_for', 'affiliations'
      return fb_user.send(field).join(', ') if fb_user.respond_to?(field)
    when 'hs_info' 
      return fb_user.hs_info.hs1_name if fb_user.hs_info
    when 'hometown_location', 'current_location'
      loc = fb_user.send(field)
      return (loc.city + ', ' + loc.state + ', ' + loc.country) if loc
    end
    fb_user.send(field)
  end
  
  
end

