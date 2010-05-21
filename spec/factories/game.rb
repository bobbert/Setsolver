# Game factories
Factory.define :game do |g|
  g.selection_count 0
  g.name            "Test Game"
  g.last_played_at  nil
  g.started_at      nil
  g.finished_at     nil
  g.created_at      { 2.minutes.ago }
  g.updated_at      { 2.minutes.ago }
end


