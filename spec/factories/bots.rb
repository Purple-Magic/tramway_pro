# frozen_string_literal: true

FactoryBot.define do
  factory :bot do
    name { generate :string }
    team { Bot.team.values.sample }
    token { generate :string }
    slug { generate :string }

    trait :quest do
#      after :create do |bot|
#        bot.steps.create attributes_for(:start_scenario_step)
#      end
    end

    factory :quest_bot, traits: [ :quest ]
  end
end
