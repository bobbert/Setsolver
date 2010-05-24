require 'spec_helper'

describe User do
  before(:each) do
    @user = Factory(:user)
  end

  it "should have a name" do
    @user.name.length > 0
  end

  it "should create a new Player when saved" do
    @user.player.should be
  end


end
