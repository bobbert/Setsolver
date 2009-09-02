require File.dirname(__FILE__) + '/../test_helper'

class DeckTest < ActiveSupport::TestCase
  fixtures :cardfaces, :cards, :decks

  # The Set game has 81 cards, representing 3x3x3x3 attributes.
  def test_fixture_decks_should_have_eighty_one_cards
    decks = Deck.find(:all)
    decks.each do |deck|
      assert_equal deck.cards.length, 81,
	"Fixture deck ##{deck.id}'s length is #{deck.cards.length}, should have 81."
    end
  end

  # Creating a new deck should load cards automatically.
  def test_new_deck_should_autoload_cards
    test_deck = Deck.new
    test_deck.save
    assert_equal test_deck.cards.length, 81,
      "New deck has #{test_deck.cards.length} cards, should have 81."
  end

  # New decks should have all facedown cards.
  def test_new_decks_should_have_all_facedown_cards
    test_deck = Deck.new
    test_deck.save
    assert_equal test_deck.facedown_length, test_deck.cards.length,
	"Number of facedown cards is #{test_deck.cards.length}, should be all 81 cards."
    assert_equal test_deck.number_in_play, 0,
	"Number of cards in play is #{test_deck.cards.length}, should be 0."
  end

  # testing whether deck deals cards successfully.
  def test_deck_should_deal_cards
    test_deck = Deck.new
    test_deck.save
    test_deck.deal 3
    assert_equal test_deck.facedown_length, 78,
	"Number of facedown cards after dealing 3 is #{test_deck.facedown_length}, should be 78."
    assert_equal test_deck.number_in_play, 3,
	"Number of cards in play is #{test_deck.cards.length}, should be 3."

    test_deck.deal 9
    assert_equal test_deck.facedown_length, 69,
	"Number of facedown cards after dealing 9 more is #{test_deck.facedown_length}, should be 69."
    assert_equal test_deck.number_in_play, 12,
	"Number of cards in play is #{test_deck.cards.length}, should be 12."

  end

  # testing whether deck deals cards successfully.
  def test_deck_should_empty_and_reset
    test_deck = Deck.new
    test_deck.save
    assert_equal test_deck.facedown_length, test_deck.cards.length,
	"Number of facedown cards in new deck is #{test_deck.facedown_length}, should be 81."
    assert_equal test_deck.in_play.length, 0,
	"Number of in-play cards in new deck is #{test_deck.facedown_length}, should be 0."
    assert !(test_deck.all_dealt?),
	"Cards in new deck should not be all dealt out."

    test_deck.deal 81
    assert_equal test_deck.facedown_length, 0,
	"Number of facedown cards in dealt out deck is #{test_deck.facedown_length}, should be 0."
    assert_equal test_deck.in_play.length, 81,
	"Number of in-play cards in dealt out deck is #{test_deck.facedown_length}, should be 81."
    assert test_deck.all_dealt?,
	"Cards in empty deck should be all dealt out."

    test_deck.reset
    assert_equal test_deck.facedown_length, test_deck.cards.length,
	"Number of facedown cards in reset deck is #{test_deck.facedown_length}, should be 81."
    assert_equal test_deck.in_play.length, 0,
	"Number of in-play cards in reset deck is #{test_deck.facedown_length}, should be 0."
    assert !(test_deck.all_dealt?),
	"Cards in reset deck should not be all dealt out."

  end

end
