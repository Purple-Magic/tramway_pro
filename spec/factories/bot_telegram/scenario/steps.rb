# frozen_string_literal: true

FactoryBot.define do
  factory :bot_telegram_scenario_step, class: 'BotTelegram::Scenario::Step' do
    name { generate :string }
    text { generate :string }
    bot { create :bot }
    project_id { Project.find_by(title: 'RedMagic').id }

    factory :start_scenario_step, traits: [:start]
    factory :start_scenario_step_with_next_step, traits: %i[start with_next_step]
    factory :type_answer_scenario_step, traits: [:type_answer]

    trait :start do
      name { :start }
      text { 'This is start message' }
    end

    trait :with_next_step do
      options do
        {
          next: bot.steps.create!(
            **attributes_for(:type_answer_scenario_step, text: 'This is next step of some another step'),
            bot: bot
          ).name
        }
      end
      delay { 3 }
    end

    trait :type_answer do
      options do
        answer_1 = Faker::Creature::Animal.name.downcase
        answer_2 = Faker::Creature::Animal.name.downcase
        step_by_answer = create(:bot_telegram_scenario_step, bot: bot, text: 'This is step by answer').name
        hint = create(
          :bot_telegram_scenario_step,
          bot: bot,
          options: {
            answer_1 => step_by_answer,
            answer_2 => step_by_answer
          }
        ).name

        {
          answer_1 => step_by_answer,
          answer_2 => step_by_answer,
          'подсказка' => hint
        }
      end

      reply_markup do
        {
          keyboard: ['Подсказка']
        }
      end
    end
  end
end
