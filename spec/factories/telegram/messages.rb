FactoryBot.define do
  factory :telegram_message, class: 'Telegram::Bot::Types::Message' do
    from { build :telegram_user }
  end
end
