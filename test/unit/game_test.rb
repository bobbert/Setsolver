require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActiveSupport::TestCase

  # checking if existing games can find deck and cards
  def test_each_fixture_game_should_have_deck_and_cards
    games = Game.find(:all)
    games.each do |game|
      assert_equal game.decks.length, 1, 
	"Fixture game ##{game.id} has #{game.decks.length} decks, should have 1."

      assert_not_nil game.current_deck
	"Fixture game ##{game.id} should have a current deck loaded."

      assert_equal game.current_deck.cards.length, 81,
	"Fixture game ##{game.id} has #{game.decks.length} cards, should have 81."
    end
  end

  # Creating a new game should load deck and cards automatically.
  def test_new_deck_should_autoload_deck_and_cards
    test_game = Game.new
    test_game.save
    assert_equal test_game.decks.length, 1,
      "New game has #{test_game.decks.length} decks, should have 1."

    assert_not_nil test_game.current_deck,
      "New game should have a current deck loaded."

    assert_equal test_game.current_deck.cards.length, 81,
      "New game has #{test_game.current_deck.cards.length} cards, should have 81."
  end

end
