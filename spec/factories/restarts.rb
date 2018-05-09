FactoryBot.define do
  factory :restart do
    heroku_application { build(:heroku_application) }
    restarted_at "2018-05-09 15:30:13"
  end
end
