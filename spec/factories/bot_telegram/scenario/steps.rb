FactoryBot.define do
  factory :bot_telegram_scenario_step, class: 'BotTelegram::Scenario::Step' do
    name { generate :string }
    text { generate :string }
    bot { create :bot }

    trait :start do
      name { :start }
      text { 'This is start message' }
    end

    trait :with_next_step do
      options do
        {
          next: bot.steps.create!(
            attributes_for(:type_answer_scenario_step, text: 'This is next step of some another step')
          ).name,
        }
      end
      delay { generate :integer }
    end

    trait :type_answer do
      options do
        answer_1 = Faker::Creature::Animal.name.downcase
        answer_2 = Faker::Creature::Animal.name.downcase
        next_step = create(:bot_telegram_scenario_step).name
        hint = create(
          :bot_telegram_scenario_step,
          options: {
            answer_1 => next_step,
            answer_2 => next_step
          }
        ).name

        {
          answer_1 => next_step,
          answer_2 => next_step,
          'подсказка' => hint
        }
      end

      reply_markup do 
        {
          keyboard: [ 'Подсказка' ]
        }
      end
    end

    factory :start_scenario_step, traits: [ :start ]
    factory :start_scenario_step_with_next_step, traits: [ :start, :with_next_step ]
    factory :type_answer_scenario_step, traits: [ :type_answer ]
  end
end
