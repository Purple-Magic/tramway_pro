FactoryBot.define do
  factory :telegram_callback_query, class: 'Telegram::Bot::Types::CallbackQuery' do
    factory :create_company_telegram_callback_query, traits: [ :create_company ]

    trait :create_company do
      data do
        {
          command: :create_company
        }.to_json
      end
    end

    ::BotTelegram::BenchkillerBot::Command::COMMANDS.each do |command|
      unless command.in? [ :start ]
        factory "#{command}_telegram_callback_query", traits: [ command ]

        trait command do
          data do
            {
              command: command
            }.to_json
          end
        end
      end
    end
  end
end
