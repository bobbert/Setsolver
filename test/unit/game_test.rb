require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActiveSupport::TestCase
  fixtures :cardfaces

  # checking if existing games can find deck and cards
  def test_fixture_games_should_have_deck_and_cards
    games = Game.find(:all)
    games.each do |game|
      assert (game.decks.length >= 1), 
	"Fixture game ##{game.id} has #{game.decks.length} decks, should have at least 1."

      assert_not_nil game.current_deck
	"Fixture game ##{game.id} should have a current deck loaded."

      assert_equal game.current_deck.cards.length, 81,
	"Fixture game ##{game.id} has #{game.decks.length} cards, should have 81."
    end
  end

  # Creating a new game should load deck and cards automatically.
  def test_unshuffled_game_should_fill_board_and_find_sets
    test_game = Game.find 1

    assert_equal test_game.field.length, 0,
      "New Game field has #{test_game.field.length} cards, should have 0 cards."

    # calling routine to load Set board
    assert_not_nil test_game.refresh_field,
      "Field refreshing routine was not successful."

    assert_equal test_game.field.length, Game::FIELD_SIZE,
      "Refreshed game field has #{test_game.field.length} cards, should have default value #{Game::FIELD_SIZE} cards."

    assert_equal test_game.set_count, 13,
      "Initial game field has #{test_game.decks.length} sets, should have 13."
  end

  # checking if existing games have cards in the active game field
  def test_fixture_games_should_have_empty_gamefield
    games = Game.find(:all)
    games.each do |game|
      assert_equal game.current_deck.facedown_length, 81,
	"Fixture game ##{game.id} has #{game.current_deck.facedown_length} cards facedown, should have 81."

      assert_equal game.field.length, 0,
	"Fixture game ##{game.id} has #{game.field.length} cards in active field, should have 0."

    end
  end

#   # Creating a new game should load deck and cards automatically.
#   def test_new_game_should_autoload_deck_and_cards
#     test_game2 = Game.new
#     test_game2.save
#     assert_equal test_game2.decks.length, 1,
#       "New game has #{test_game2.decks.length} decks, should have 1."
# 
#     assert_not_nil test_game2.current_deck,
#       "New game should have a current deck loaded."
# 
#     assert_equal test_game2.current_deck.cards.length, 81,
#       "New game has #{test_game2.current_deck.cards.length} cards, should have 81."
#   end

end
