# Threecardset factories
Factory.define :threecardset do |tcs|
#  tcs.cards {|cards| [cards.association(:faceup_card), cards.association(:faceup_card), cards.association(:faceup_card)] } 
  tcs.cards do |cards|
    [:faceup_card, :faceup_card2, :faceup_card3].map {|fc_sym| Factory(fc_sym) }
  end
  tcs.player { Player.first || Factory(:player) }
  tcs.created_at { 5.minutes.ago }
  tcs.updated_at { 5.minutes.ago }
end
