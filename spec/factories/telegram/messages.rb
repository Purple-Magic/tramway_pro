# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_message, class: 'Telegram::Bot::Types::Message' do
    from { build :telegram_user }
    chat { build :telegram_chat }
  end
end
