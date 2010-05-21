# Deck factories
Factory.define :deck do |d|
  d.created_at { 5.minutes.ago }
  d.updated_at { 5.minutes.ago }
  d.finished_at nil
end

Factory.define :finished_deck, :class => :deck do |d|
  d.created_at  { 30.minutes.ago }
  d.updated_at  { 5.minutes.ago }
  d.finished_at { 5.minutes.ago }
end


