# frozen_string_literal: true

FactoryBot.define do
  factory :bot do
    name { generate :string }
    team { Bot.team.values.sample }
    token { generate :string }
    slug { generate :string }

    factory :quest_bot, traits: [:quest]
    factory :bot_with_start_step, traits: [:with_start_step]
    factory :benchkiller_bot, traits: [:benchkiller]
    factory :leopold_bot, traits: [:leopold]
    factory :find_meds_bot, traits: [:find_meds]

    trait :quest do
      steps = YAML.load_file("#{Rails.root}/spec/support/quests/test_quest.yml").with_indifferent_access[:steps]
      after :create do |bot|
        steps.each do |current_step|
          bot.scenario_steps.create!(**attributes_for(:bot_telegram_scenario_step), **current_step)
        end
      end
    end

    trait :with_start_step do
      after :create do |bot|
        bot.scenario_steps.create! attributes_for(:start_scenario_step)
      end
    end

    trait :benchkiller do
      options do
        {
          custom: true,
          scenario: :benchkiller_bot
        }
      end
    end

    trait :leopold do
      options do
        {
          custom: true,
          scenario: :leopold
        }
      end

      after :create do |bot|
        bot.update_column :id, ::BotTelegram::Leopold::Scenario::BOT_ID
      end
    end

    trait :find_meds do
      options do
        {
          custom: true,
          scenario: :find_meds_bot
        }
      end
    end
  end
end
