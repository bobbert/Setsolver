require 'spec_helper'

describe Deck do
  before(:each) do
    @deck = Factory(:deck)
    @number_of_cardfaces = Cardface.find(:all).length
  end

  it "should contain one card per cardface" do
    @deck.cards.length.should == @number_of_cardfaces
  end  

  it "should be unshuffled by default" do
    @deck.cards.map {|c| c.facedown_position }.should == (1..@number_of_cardfaces).to_a
  end

  it "should change deck ordering when shuffled" do
    @deck.shuffle
    @deck.cards.map {|c| c.facedown_position }.should_not == (1..@number_of_cardfaces).to_a
  end

  it "should contain all facedown cards by default" do
    @deck.cards.select {|c| c.faceup? }.length.should == 0
    @deck.cards.select {|c| c.facedown? }.length.should == @number_of_cardfaces
  end

  it "should turn the three dealt cards faceup, if three cards are dealt" do
    cards_dealt = @deck.deal 3
    @deck.cards.select {|c| c.faceup? }.sort.should == cards_dealt.sort
  end

  it "should give the first dealt card postion number 1" do
    card_dealt = @deck.deal 1
    card_dealt.first.faceup_position.should == 1
  end

  it "should give the second dealt card postion number 2" do
    @deck.deal 1
    card_dealt = @deck.deal 1
    card_dealt.first.faceup_position.should == 2
  end

  it "should change next faceup position when dealing cards" do
    @deck.next_faceup_position.should == 1
    @deck.deal 12
    @deck.next_faceup_position.should == 13
  end

  describe 'when all the cards are dealt' do
    before(:each) do
      @deck.deal @number_of_cardfaces
    end

    it "should stop dealing out cards" do
      card_dealt = @deck.deal 1
      card_dealt.should == []
    end

    it "should have all faceup cards" do
      @deck.cards.select {|c| c.faceup? }.length.should == @number_of_cardfaces
      @deck.cards.select {|c| c.facedown? }.length.should == 0
    end

    it "should go back to all cards facedown when resetting" do
      @deck.reset
      @deck.cards.select {|c| c.faceup? }.length.should == 0
      @deck.cards.select {|c| c.facedown? }.length.should == @number_of_cardfaces
    end
  end  # 'when all the cards are dealt' context

end