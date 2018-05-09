FactoryBot.define do
  factory :heroku_application do
    name "coolapp-production"
    grace_period 1800
  end
end
