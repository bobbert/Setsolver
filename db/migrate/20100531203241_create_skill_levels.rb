class CreateSkillLevels < ActiveRecord::Migration

  SkillLevels = { 'Beginner' => 60, 'Intermediate' => 30, 'Skilled' => 15,
                  'Advanced' => 10, 'Expert' => 7, 'Elite' => 5, 'Ultra Kickass' => 3 }

  def self.up
    create_table :skill_levels do |t|
      t.string :name
      t.integer :threshold_time_in_seconds
      t.timestamps
    end
    
    # seeding database, starting with Beginner
    SkillLevels.sort{|sl_prev,sl_next| sl_next[1] <=> sl_prev[1] }.each do |sl_name, sl_time|
      sl = SkillLevel.new :name => sl_name, :threshold_time_in_seconds => sl_time
      sl.save
    end
  end

  def self.down
    drop_table :skill_levels
  end
end
