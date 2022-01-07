FactoryBot.define do
  factory :bot_telegram_scenario_step, class: 'BotTelegram::Scenario::Step' do
    name { generate :string }
    text { generate :string }

    trait :start do
      name { :start }
      text { '/start' }
      options do
        {
          next: build(:type_answer_scenario_step).name,
        }
      end
      delay { generate :integer }
    end

    factory :start_scenario_step, traits: [ :start ]

    trait :type_answer do
      options do
        answer_1 = Faker::Creature::Animal.name 
        answer_2 = Faker::Creature::Animal.name 
        next_step = build(:bot_telegram_scenario_step).name
        hint = build(
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
          keyboard: 'Подсказка'
        }
      end
    end

    factory :type_answer_scenario_step, traits: [ :type_answer ]
  end
end
