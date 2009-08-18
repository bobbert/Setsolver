# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 10) do

  create_table "cardfaces", :force => true do |t|
    t.integer "number"
    t.text    "color"
    t.text    "color_abbrev"
    t.text    "shading"
    t.text    "shading_abbrev"
    t.text    "shape"
    t.text    "shape_abbrev"
  end

  create_table "cards", :force => true do |t|
    t.integer "cardface_id"
    t.integer "deck_id"
    t.integer "facedown_position"
    t.integer "faceup_position"
    t.integer "claimed_by"
  end

  add_index "cards", ["cardface_id"], :name => "cardface_card_id_fkey"
  add_index "cards", ["deck_id"], :name => "deck_card_id_fkey"

  create_table "decks", :force => true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "finished_at"
  end

  add_index "decks", ["game_id"], :name => "game_deck_id_fkey"

  create_table "games", :force => true do |t|
    t.text     "autoshuffle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "finished_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "score",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["user_id"], :name => "game_player_id_fkey"
  add_index "players", ["game_id"], :name => "user_player_id_fkey"

  create_table "users", :force => true do |t|
    t.string   "fname",      :limit => 60
    t.string   "lname",      :limit => 60
    t.integer  "rating",                   :default => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
