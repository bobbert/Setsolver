# Player factories
Factory.define :player do |p|
  p.user            { User.first || Factory(:user) }
  p.created_at      { 2.minutes.ago }
  p.updated_at      { 2.minutes.ago }
end
