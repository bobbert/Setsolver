# Player factories
Factory.define :score do |sc|
  sc.game            { Game.first || Factory(:game) }
  sc.player          { Player.first || Factory(:player) }
  sc.created_at      { 2.minutes.ago }
  sc.updated_at      { 2.minutes.ago }
end
