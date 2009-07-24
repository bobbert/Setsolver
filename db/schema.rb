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

ActiveRecord::Schema.define(:version => 9) do

  create_table "cardfaces", :force => true do |t|
    t.integer "number_id"
    t.integer "color_id"
    t.integer "shading_id"
    t.integer "shape_id"
  end

  add_index "cardfaces", ["number_id"], :name => "number_cardface_id_fkey"
  add_index "cardfaces", ["shading_id"], :name => "shading_cardface_id_fkey"
  add_index "cardfaces", ["color_id"], :name => "color_cardface_id_fkey"
  add_index "cardfaces", ["shape_id"], :name => "shape_cardface_id_fkey"

  create_table "cards", :force => true do |t|
    t.integer "cardface_id"
    t.integer "deck_id"
    t.integer "facedown_position"
    t.integer "faceup_position"
    t.integer "claimed_by"
  end

  add_index "cards", ["cardface_id"], :name => "cardface_card_id_fkey"
  add_index "cards", ["deck_id"], :name => "deck_card_id_fkey"

  create_table "colors", :force => true do |t|
    t.text "name"
    t.text "abbrev"
  end

  create_table "decks", :force => true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "decks", ["game_id"], :name => "game_deck_id_fkey"

  create_table "games", :force => true do |t|
    t.integer  "deck_count",  :default => 0
    t.text     "autoshuffle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_players", :id => false, :force => true do |t|
    t.integer "game_id"
    t.integer "player_id"
  end

  add_index "games_players", ["game_id"], :name => "game_games_players_id_fkey"
  add_index "games_players", ["player_id"], :name => "player_games_players_id_fkey"

  create_table "numbers", :force => true do |t|
    t.text "name"
    t.text "abbrev"
  end

  create_table "players", :force => true do |t|
    t.text     "name"
    t.integer  "sets",       :default => 0
    t.integer  "wins",       :default => 0
    t.integer  "losses",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shadings", :force => true do |t|
    t.text "name"
    t.text "abbrev"
  end

  create_table "shapes", :force => true do |t|
    t.text "name"
    t.text "abbrev"
  end

end
