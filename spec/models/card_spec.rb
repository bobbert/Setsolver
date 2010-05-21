require 'spec_helper'

describe Card do
  before(:each) do
    @card = Factory(:first_card)
  end

  describe 'when both facedown and faceup positions exist' do
    it "should not be valid" do
      @invalid_card = Factory(:first_card)
      @invalid_card.faceup_position = 1
      @invalid_card.save
      @invalid_card.valid?.should_not be
    end
  end
  
  describe 'when neither facedown nor faceup positions exist' do
    it "should not be valid" do
      @invalid_card = Factory(:first_card)
      @invalid_card.facedown_position = nil
      @invalid_card.save
      @invalid_card.valid?.should_not be
    end
  end
  
  describe 'when going through a full deck' do
    before(:each) do
      @cardfaces = Cardface.find :all
      @all_cards = @cardfaces.map {|cf| Factory(:card, :cardface_id => cf.id) }
    end

    it "should all have unique names" do
      @cardnames = @all_cards.map {|c| c.name}
      @cardnames.should == @cardnames.uniq
    end

  end
end