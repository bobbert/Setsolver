require File.dirname(__FILE__) + '/../test_helper'

class CardTest < ActiveSupport::TestCase
  fixtures :cardfaces, :cards, :decks

  # The Set game has 81 cards, representing 3x3x3x3 attributes.
  def test_should_have_two_decks_times_eighty_one_cards
    vals = Card.find(:all)
    num_decks = Deck.find(:all).length
    num_cards = num_decks * 81

    assert_equal vals.length, num_cards,
      "Numbers has #{vals.length} values, should have #{num_cards}."
    nm = vals.map {|s| s.to_s }
    assert_equal nm.uniq.length, 81,
      "Numbers has #{nm.uniq.length} unique full description names, should have 81."
    abv = vals.map {|s| s.img_name }
    assert_equal abv.uniq.length, 81,
      "Numbers has #{abv.uniq.length} unique image names, should have 81."
  end


end
