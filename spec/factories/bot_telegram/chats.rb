FactoryBot.define do
  factory :bot_telegram_chat, class: 'BotTelegram::Chat' do
    telegram_chat_id { generate :string }

    factory :bot_telegram_private_chat, traits: [ :private ]

    trait :private do
      chat_type { :private }
    end
  end
end
