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

ActiveRecord::Schema.define(:version => 9) do

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
    t.integer "claimed_by"
  end

  add_index "cards", ["cardface_id"], :name => "cardface_card_id_fkey"
  add_index "cards", ["claimed_by"], :name => "card_claimed_by_fkey"
  add_index "cards", ["deck_id"], :name => "deck_card_id_fkey"

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
    t.string   "fname",      :limit => 50
    t.string   "lname",      :limit => 50
    t.integer  "wins",                     :default => 0
    t.integer  "losses",                   :default => 0
    t.integer  "rating",                   :default => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "points",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["game_id"], :name => "score_game_id_fkey"
  add_index "scores", ["player_id"], :name => "score_player_id_fkey"

end
