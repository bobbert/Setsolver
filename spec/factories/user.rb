# User factories
Factory.define :user do |u|
  u.facebook_id      1
  u.name             "Test User1"
  u.session_key      "12345678901234567890"
end

Factory.define :user2 do |u|
  u.facebook_id      2
  u.name             "Test User2"
  u.session_key      "01234567890123456789"
end

