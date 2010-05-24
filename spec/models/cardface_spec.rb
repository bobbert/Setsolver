require 'spec_helper'

describe Cardface do
  before(:each) do
    # Cardfaces are pre-loaded into the database via fixtures, because they are
    # an essential part of playing the Set game.
    @all_cardfaces = Cardface.find(:all)
  end

  it "should have at least one cardface" do
    @all_cardfaces.length.should > 0
  end

  it "should all have unique attributes" do
    attributes = @all_cardfaces.map {|cardface| [cardface.number, cardface.color ,cardface.shape, cardface.shading] }
    attributes.uniq.length.should == @all_cardfaces.length
  end

  it "should all have unique descriptions" do
    names = @all_cardfaces.map {|cardface| cardface.name }
    names.uniq.length.should == @all_cardfaces.length
  end

  it "should all have unique abbreviated names" do
    names = @all_cardfaces.map {|cardface| cardface.abbrev }
    names.uniq.length.should == @all_cardfaces.length
  end

  it "should have equal numbers of all attributes" do
    @number_of_each_attr = (@all_cardfaces.length / 3)
    Cardface::ATTR.each do |attr|
      counters = {}
      counters.default = 0
      @all_cardfaces.each {|c| counters[c.send(attr)] += 1 }
      counters.values.should == [@number_of_each_attr,@number_of_each_attr,@number_of_each_attr]
    end
  end

  it "should all have a set card image" do
    final_count_of_correct_images = @all_cardfaces.inject(0) do |correct_count, cardface| 
      correct_count += 1 if File.exist?("#{RAILS_ROOT}/public/#{cardface.img_path}")
      correct_count
    end
    final_count_of_correct_images.should == @all_cardfaces.length
  end

  it "should all have a small set card image" do
    final_count_of_correct_images = @all_cardfaces.inject(0) do |correct_count, cardface| 
      correct_count += 1 if File.exist?("#{RAILS_ROOT}/public/#{cardface.small_img_path}")
      correct_count
    end
    final_count_of_correct_images.should == @all_cardfaces.length
  end

end
