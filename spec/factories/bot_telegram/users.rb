# frozen_string_literal: true

FactoryBot.define do
  factory :bot_telegram_user, class: 'BotTelegram::User' do
    telegram_id { '123' }
  end
end
