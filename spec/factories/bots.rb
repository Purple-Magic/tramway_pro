# frozen_string_literal: true

FactoryBot.define do
  factory :bot do
    name { generate :string }
    team { Bot.team.values.sample }
    token { generate :string }
    slug { generate :string }

    factory :quest_bot, traits: [:quest]
    factory :bot_with_start_step, traits: [ :with_start_step ]

    trait :quest do
#      steps = YAML.load_file("#{Rails.root}/support/quests/test_quest.yml")
#      after :create do
#        steps.each do |current_step|
#          create :bot_telegram_scenario_step, **current_step
#        end
#      end
    end

    trait :with_start_step do
      after :create do |bot|
        bot.steps.create! attributes_for(:start_scenario_step)
      end
    end
  end
end
