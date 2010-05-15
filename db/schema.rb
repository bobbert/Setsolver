# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100513184801) do

  create_table "cardfaces", :force => true do |t|
    t.integer "number"
    t.text    "color",          :limit => 255
    t.text    "color_abbrev",   :limit => 255
    t.text    "shading",        :limit => 255
    t.text    "shading_abbrev", :limit => 255
    t.text    "shape",          :limit => 255
    t.text    "shape_abbrev",   :limit => 255
  end

  create_table "cards", :force => true do |t|
    t.integer "cardface_id"
    t.integer "deck_id"
    t.integer "facedown_position"
    t.integer "faceup_position"
    t.integer "threecardset_id"
  end

  add_index "cards", ["cardface_id"], :name => "cardface_card_id_fkey"
  add_index "cards", ["deck_id"], :name => "deck_card_id_fkey"
  add_index "cards", ["threecardset_id"], :name => "card_threecardset_id_fkey"

  create_table "decks", :force => true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "finished_at"
  end

  add_index "decks", ["game_id"], :name => "game_deck_id_fkey"

  create_table "games", :force => true do |t|
    t.integer  "selection_count",               :default => 0
    t.string   "name",            :limit => 50
    t.date     "last_played_at"
    t.date     "started_at"
    t.date     "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "wins",       :default => 0
    t.integer  "losses",     :default => 0
    t.integer  "rating",     :default => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "players", ["user_id"], :name => "player_user_id_fkey"

  create_table "scores", :force => true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "points",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["game_id"], :name => "score_game_id_fkey"
  add_index "scores", ["player_id"], :name => "score_player_id_fkey"

  create_table "threecardsets", :force => true do |t|
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "facebook_id",          :limit => 8
    t.string   "session_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "political"
    t.string   "pic_small"
    t.string   "name"
    t.string   "quotes"
    t.string   "is_app_user"
    t.string   "tv"
    t.string   "profile_update_time"
    t.string   "meeting_sex"
    t.string   "hs_info"
    t.string   "timezone"
    t.string   "relationship_status"
    t.string   "hometown_location"
    t.string   "about_me"
    t.string   "wall_count"
    t.string   "significant_other_id"
    t.string   "pic_big"
    t.string   "music"
    t.string   "work_history"
    t.string   "sex"
    t.string   "religion"
    t.string   "notes_count"
    t.string   "activities"
    t.string   "pic_square"
    t.string   "movies"
    t.string   "has_added_app"
    t.string   "education_history"
    t.string   "birthday"
    t.string   "birthday_date"
    t.string   "first_name"
    t.string   "meeting_for"
    t.string   "last_name"
    t.string   "interests"
    t.string   "current_location"
    t.string   "pic"
    t.string   "books"
    t.string   "affiliations"
    t.string   "locale"
    t.string   "profile_url"
    t.string   "proxied_email"
    t.string   "email_hashes"
    t.string   "allowed_restrictions"
    t.string   "pic_with_logo"
    t.string   "pic_big_with_logo"
    t.string   "pic_small_with_logo"
    t.string   "pic_square_with_logo"
    t.string   "online_presence"
    t.string   "verified"
    t.string   "profile_blurb"
    t.string   "username"
    t.string   "website"
    t.string   "is_blocked"
    t.string   "family"
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id", :unique => true

end
