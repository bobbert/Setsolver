class SkillLevel < ActiveRecord::Base
  has_many :players

  # return skill level corresponding to average seconds passed in
  def self.highest_skill_level( avg_seconds )
    last_sl_passed = nil
    SkillLevel.find(:all).sort.find do |sl|
      last_sl_passed = sl if sl.threshold_time_in_seconds > avg_seconds
      last_sl_passed.blank?
    end
    last_sl_passed
  end

  # return True if time passed in is good enough to promote player
  def promote?( avg_seconds )
    hsl = SkillLevel.highest_skill_level( avg_seconds )
    (hsl > self) if hsl
  end

  # greater-than operator (RWP: should be included with spaceship)
  def >(other)
    (self <=> other) > 0
  end
  
  # sorting operator: sorts skill levels from lowest to highest, by difficulty
  def <=>(other)
    other.threshold_time_in_seconds <=> self.threshold_time_in_seconds
  end

end
