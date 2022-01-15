FactoryBot.define do
  factory :bot_telegram_message, class: 'BotTelegram::Message' do
    user { create :bot_telegram_user, telegram_id: generate(:string) }
  end
end
