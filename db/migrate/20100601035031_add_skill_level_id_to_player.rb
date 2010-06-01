class AddSkillLevelIdToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :skill_level_id, :integer
  end

  def self.down
    remove_column :players, :skill_level_id
  end
end
