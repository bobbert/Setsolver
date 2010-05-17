class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string
    add_column :users, :political, :string
    add_column :users, :pic_small, :string
    add_column :users, :name, :string
    add_column :users, :quotes, :string
    add_column :users, :is_app_user, :string
    add_column :users, :tv, :string
    add_column :users, :profile_update_time, :string
    add_column :users, :meeting_sex, :string
    add_column :users, :hs_info, :string
    add_column :users, :timezone, :string
    add_column :users, :relationship_status, :string
    add_column :users, :hometown_location, :string
    add_column :users, :about_me, :string
    add_column :users, :wall_count, :string
    add_column :users, :significant_other_id, :string
    add_column :users, :pic_big, :string
    add_column :users, :music, :string
    add_column :users, :work_history, :string
    add_column :users, :sex, :string
    add_column :users, :religion, :string
    add_column :users, :notes_count, :string
    add_column :users, :activities, :string
    add_column :users, :pic_square, :string
    add_column :users, :movies, :string
    add_column :users, :has_added_app, :string
    add_column :users, :education_history, :string
    add_column :users, :birthday, :string
    add_column :users, :birthday_date, :string
    add_column :users, :first_name, :string
    add_column :users, :meeting_for, :string
    add_column :users, :last_name, :string
    add_column :users, :interests, :string
    add_column :users, :current_location, :string
    add_column :users, :pic, :string
    add_column :users, :books, :string
    add_column :users, :affiliations, :string
    add_column :users, :locale, :string
    add_column :users, :profile_url, :string
    add_column :users, :proxied_email, :string
    add_column :users, :email_hashes, :string
    add_column :users, :allowed_restrictions, :string
    add_column :users, :pic_with_logo, :string
    add_column :users, :pic_big_with_logo, :string
    add_column :users, :pic_small_with_logo, :string
    add_column :users, :pic_square_with_logo, :string
    add_column :users, :online_presence, :string
    add_column :users, :verified, :string
    add_column :users, :profile_blurb, :string
    add_column :users, :username, :string
    add_column :users, :website, :string
    add_column :users, :is_blocked, :string
    add_column :users, :family, :string
    add_column :users, :email, :string
  end

  def self.down
    remove_column :users, :status
    remove_column :users, :political
    remove_column :users, :pic_small
    remove_column :users, :name
    remove_column :users, :quotes
    remove_column :users, :is_app_user
    remove_column :users, :tv
    remove_column :users, :profile_update_time
    remove_column :users, :meeting_sex
    remove_column :users, :hs_info
    remove_column :users, :timezone
    remove_column :users, :relationship_status
    remove_column :users, :hometown_location
    remove_column :users, :about_me
    remove_column :users, :wall_count
    remove_column :users, :significant_other_id
    remove_column :users, :pic_big
    remove_column :users, :music
    remove_column :users, :work_history
    remove_column :users, :sex
    remove_column :users, :religion
    remove_column :users, :notes_count
    remove_column :users, :activities
    remove_column :users, :pic_square
    remove_column :users, :movies
    remove_column :users, :has_added_app
    remove_column :users, :education_history
    remove_column :users, :birthday
    remove_column :users, :birthday_date
    remove_column :users, :first_name
    remove_column :users, :meeting_for
    remove_column :users, :last_name
    remove_column :users, :interests
    remove_column :users, :current_location
    remove_column :users, :pic
    remove_column :users, :books
    remove_column :users, :affiliations
    remove_column :users, :locale
    remove_column :users, :profile_url
    remove_column :users, :proxied_email
    remove_column :users, :email_hashes
    remove_column :users, :allowed_restrictions
    remove_column :users, :pic_with_logo
    remove_column :users, :pic_big_with_logo
    remove_column :users, :pic_small_with_logo
    remove_column :users, :pic_square_with_logo
    remove_column :users, :online_presence
    remove_column :users, :verified
    remove_column :users, :profile_blurb
    remove_column :users, :username
    remove_column :users, :website
    remove_column :users, :is_blocked
    remove_column :users, :family
    remove_column :users, :email
  end
end
