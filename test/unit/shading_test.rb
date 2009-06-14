require File.dirname(__FILE__) + '/../test_helper'

class ShadingTest < ActiveSupport::TestCase
  # The Set game is dependent on 3x3x3x3 attributes.
  def test_should_have_three_fields
    vals = Shading.find(:all)
    assert (vals.length == 3), "Shadings has #{vals.length} values, should have 3."
    nm = vals.map {|s| s.name }
    assert (nm.uniq.length == 3),
      "Shadings has #{nm.uniq.length} unique full names, should have 3."
    abv = vals.map {|s| s.abbrev }
    assert (abv.uniq.length == 3),
      "Shadings has #{abv.uniq.length} unique abbreviated names, should have 3."
  end

end
