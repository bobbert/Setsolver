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

  create_table "cards", :force => true do |t|
    t.integer "number_id"
    t.integer "color_id"
    t.integer "shading_id"
    t.integer "shape_id"
  end

  add_index "cards", ["number_id"], :name => "number_card_id_fkey"
  add_index "cards", ["shading_id"], :name => "shading_card_id_fkey"
  add_index "cards", ["color_id"], :name => "color_card_id_fkey"
  add_index "cards", ["shape_id"], :name => "shape_card_id_fkey"

  create_table "cards_decks", :id => false, :force => true do |t|
    t.integer "card_id"
    t.integer "deck_id"
  end

  add_index "cards_decks", ["card_id"], :name => "card_cards_deck_id_fkey"
  add_index "cards_decks", ["deck_id"], :name => "deck_cards_deck_id_fkey"

  create_table "cards_games", :id => false, :force => true do |t|
    t.integer "card_id"
    t.integer "game_id"
  end

  add_index "cards_games", ["card_id"], :name => "card_cards_game_id_fkey"
  add_index "cards_games", ["game_id"], :name => "game_cards_game_id_fkey"

  create_table "colors", :force => true do |t|
    t.string "name",   :limit => 30
    t.string "abbrev", :limit => 3
  end

  create_table "decks", :force => true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "deck_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "numbers", :force => true do |t|
    t.string "name",   :limit => 30
    t.string "abbrev", :limit => 3
  end

  create_table "shadings", :force => true do |t|
    t.string "name",   :limit => 30
    t.string "abbrev", :limit => 3
  end

  create_table "shapes", :force => true do |t|
    t.string "name",   :limit => 30
    t.string "abbrev", :limit => 3
  end

end
