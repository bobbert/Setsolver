require 'spec_helper'

describe Threecardset do
  before(:each) do
    @player = Factory(:player)
    @threecardset = Factory.build(:threecardset)
  end

  it "should not save correctly if cards are not claimed by a player" do
    [:faceup_card, :faceup_card2, :faceup_card3].each do |factory_card_type|
      @threecardset.cards << Factory(factory_card_type)
    end
    @threecardset.save.should_not be
  end

  it "should not save correctly if less than three card exist in set" do
    [:faceup_card, :faceup_card2].each do |factory_card_type|
      @threecardset.cards << Factory(factory_card_type)
    end
    @threecardset.player = @player
    @threecardset.save.should_not be
  end

  describe 'when cards come from same deck and player exists' do
    before(:each) do
      @deck = Factory(:deck)
      [:faceup_card, :faceup_card2, :faceup_card3].each do |factory_card_type|
         @threecardset.cards << Factory(factory_card_type, :deck => @deck)
      end
      @threecardset.player = @player
    end

    it "should save" do
      @threecardset.save.should be
    end

  end  # 'when cards come from same deck and player exists context
  
end
