# frozen_string_literal: true

FactoryBot.define do
  factory :bot_telegram_message, class: 'BotTelegram::Message' do
    user { create :bot_telegram_user, telegram_id: generate(:string) }
    text { generate(:string) }
  end
end
