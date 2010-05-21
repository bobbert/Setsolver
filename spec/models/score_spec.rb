require 'spec_helper'

describe Score do
  before(:each) do
    @score = Factory(:score)
  end

  it "should start with zero points by default" do
    @score.points.should == 0
  end
end
