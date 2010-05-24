require 'spec_helper'

describe Score do
  before(:each) do
    @score = Factory(:score)
  end

  it "should start with zero points" do
    @score.points.should == 0
  end

  it "should start with zero sets" do
    @score.sets.should == []
  end

  it "should be able to increment" do
    @score.increment
    @score.points.should == 1
  end


end
