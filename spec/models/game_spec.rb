require 'spec_helper'

describe Game do
  before(:each) do
    @game = Factory(:game)
    @number_of_cardfaces = Cardface.find(:all).length
  end

  it "should permute Set combinations correctly" do
    permutations_by_index = Game.each_cmb3(Game::FieldSize)
    permutations_by_index.length.should == permutations_by_index.uniq.length
    # checking if number of elements equals a (n 3) statistical combination
    n_3_combination_number = ((Game::FieldSize * (Game::FieldSize-1) * (Game::FieldSize-2)) / 6)
    permutations_by_index.length.should == n_3_combination_number
    # checking if all indices are in range (0 <= n < Game::FieldSize)
    permutations_by_index.each do |index_triad|
      index_triad.each do |index|
        (0...Game::FieldSize).include?(index).should be
      end
    end
  end

  it "should not be started by default" do
    @game.started?.should_not be
  end
  
  it "should have a starting deck" do
    @game.deck.should be
  end

  it "should have a full facedown deck to start" do
    @game.deck.cards.length.should == @number_of_cardfaces
    @game.deck.cards.select {|c| c.facedown? }.length.should == @number_of_cardfaces
  end

  describe 'when started with one player added' do
    before(:each) do
      @player = Factory(:player)
      @game.add_player(@player)
      @game.start
    end

    it "should have one Player" do
      @game.players.length.should == 1
      @game.players.first.should == @player
    end

    it "should have one Score object, with initial points set to zero" do
      @game.scores.length.should == 1
      @game.score(@player).points.should == 0
    end

    it "should be active" do
      @game.active?.should be
    end

    it "should have 0 cards in the gamefield by default" do
      @game.field.length.should == 0
    end

    it "should have at least #{Game::FieldSize} cards in the gamefield after making call to fill field" do
      @game.fill_gamefield_with_sets
      @game.field.length.should >= Game::FieldSize
    end

    describe 'and when finding Sets' do
      before(:each) do
        @game.fill_gamefield_with_sets
        @sets_found = @game.find_sets
      end

      it "should have at least one Set found in the gamefield" do   
        @sets_found.length.should >= 1
      end

      it "should find Sets with three cards" do   
        @sets_found.each do |set|
          set.length.should == 3
          set.map {|card| card.is_a? Card }.should == [true,true,true]
        end
      end

      it "should have Sets with 1 or 3, but never 2, common aspects of each attribute" do
        @game.deck.deal Game::FieldSize  # dealing extra cards to ensure that lots of sets get tested
        @game.field.length.should >= (2 * Game::FieldSize)
        @sets_found.each do |set|
          cardfaces = set.map {|card| card.cardface }
          Cardface::ATTR.each do |attr|
            [1,3].include?( @game.num_different_attr( attr, cardfaces ) ).should be
          end
        end
      end

      it "should allow players to make a correct set selection" do
        selected_set = @game.make_set_selection( @player, *(@sets_found.first) )
        selected_set.should be
        selected_set.cards.should == @sets_found.first
      end

      it "should not allow players to make an incorrect set selection" do
        last_bad_set = nil
         # searching for three-card "non-set" not found in sets array
        Game.each_cmb3(Game::FieldSize).find do |indices|
          last_bad_set = indices.map {|i| @game.field[i] }
          !(@sets_found.include? last_bad_set)  
        end
        @game.make_set_selection( @player, *last_bad_set ).should_not be
      end

      it "should increment the score after making a correct Set selection" do
        @game.score(@player).points.should == 0
        @game.make_set_selection( @player, *(@sets_found.first) )
        @game.score(@player).points.should == 1
      end

    end # 'and when finding Sets' context

  end  # 'when started' context

end
