# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_user, class: 'Telegram::Bot::Types::User' do
    id { '123' }
  end
end
