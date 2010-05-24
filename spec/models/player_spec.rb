require 'spec_helper'

describe Player do
  before(:each) do
    @player1 = Factory(:player)
  end

  it "should have zero games by default" do
    @player1.games.should == []
  end
end
