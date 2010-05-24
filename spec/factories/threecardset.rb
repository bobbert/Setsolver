# Threecardset factories
Factory.define :threecardset, :default_strategy => :build do |tcs|
  tcs.created_at { 5.minutes.ago }
  tcs.updated_at { 5.minutes.ago }
end
