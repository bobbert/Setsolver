require File.dirname(__FILE__) + '/../test_helper'

class DeckTest < ActiveSupport::TestCase
  fixtures :cardfaces, :cards, :decks


  # The Set game has 81 cards, representing 3x3x3x3 attributes.
  def test_eaach_deck_should_have_eighty_one_cards
    decks = Deck.find(:all)
    decks.each do |deck|
      assert_equal deck.cards.length, 81,
	"Numbers has #{deck.cards.length} values, should have 81."
    end
  end

end
