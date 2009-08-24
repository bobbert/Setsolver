require File.dirname(__FILE__) + '/../test_helper'

class CardfaceTest < ActiveSupport::TestCase
  fixtures :cardfaces

  # The Set game has 81 cards, representing 3x3x3x3 attributes.
  def test_should_have_eighty_one_cards
    vals = Cardface.find(:all)
    assert_equal vals.length, 81,
      "Numbers has #{vals.length} values, should have 81."
    nm = vals.map {|s| s.to_s }
    assert_equal nm.uniq.length, 81,
      "Numbers has #{nm.uniq.length} unique full description names, should have 81."
    abv = vals.map {|s| s.img_name }
    assert_equal abv.uniq.length, 81,
      "Numbers has #{abv.uniq.length} unique image names, should have 81."
  end

  # checking for an equal number of each of the four attributes
  def test_should_have_equal_numbers_of_each_attribute
    vals = Cardface.find(:all)
    Cardface::ATTR.each do |attr|
      counters = {}
      counters.default = 0
      vals.each {|c| counters[c.send(attr).name] += 1 }
      assert_equal counters.values.uniq, 1,
        "Cards contains an unequal number of attribute '#{attr}':\n#{counters.to_yaml}\n"
    end
  end

  # checking for an equal number of each of the four attributes
  def test_should_have_all_unique_cards
    val_attributes = Cardface.find(:all).map {|c| [c.number, c.shading, c.shape, c.color] }
    assert_equal val_attributes.length, 81,
      "Numbers has #{vals.length} values, should have 81."
    assert_equal val_attributes.uniq.length, 81,
      "Numbers has #{vals.length} unique values, should have 81."
  end

end
