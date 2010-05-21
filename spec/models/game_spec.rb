require 'spec_helper'

describe Game do
  before(:each) do
    @game = Factory(:game)
  end

  it "should not be started by default" do
    @game.started?.should_not be
  end
  
  describe 'when started' do
    before(:each) do
      @player = Factory(:player)
      @game.add_player(@player)
      @game.start
    end

    it "should be active" do
      @game.active?.should be
    end

  end  # 'when started' context

end
