class AddPostgamePublishedToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :postgame_published, :boolean
  end

  def self.down
    remove_column :games, :postgame_published
  end
end
