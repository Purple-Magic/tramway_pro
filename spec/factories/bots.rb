FactoryBot.define do
  factory :bot do
    name { generate :string }
    team { Bot.team.values.sample }
    token { generate :string }
    slug { generate :string }
  end
end
