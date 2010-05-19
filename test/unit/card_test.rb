require File.dirname(__FILE__) + '/../test_helper'

class CardTest < ActiveSupport::TestCase
  fixtures :cardfaces

   context "A Card instance" do
     setup do
       @card = Factory(:card)
     end

     should "be face down" do
       assert @card.facedown?
     end

     context "turned face-up" do
       setup do
         @card = Factory(:faceup_card)
       end

       should "not be face down" do
         assert !(@card.facedown?)
       end
     end # context "turned face-up"
   end # context "A Card instance"

end
