# frozen_string_literal: true

FactoryBot.define do
  factory :benchkiller_user, class: 'Benchkiller::User' do
    telegram_user { create :bot_telegram_user, telegram_id: SecureRandom.hex(16) }
  end
end
