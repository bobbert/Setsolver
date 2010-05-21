# Card factories
Factory.define :card do |c|
  c.facedown_position 1
  c.faceup_position nil
end

Factory.define :first_card, :class => :card do |c|
  c.cardface { Cardface.first }
  c.facedown_position 1
  c.faceup_position nil
end

Factory.define :faceup_card, :class => :card do |c|
  c.cardface { Cardface.find(1) }
  c.facedown_position nil
  c.faceup_position 1
end

Factory.define :faceup_card2, :class => :card do |c|
  c.cardface { Cardface.find(2) }
  c.facedown_position nil
  c.faceup_position 2
end

Factory.define :faceup_card3, :class => :card do |c|
  c.cardface { Cardface.find(3) }
  c.facedown_position nil
  c.faceup_position 3
end
