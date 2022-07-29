# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_message, class: 'Telegram::Bot::Types::Message' do
    from { build :telegram_user }
    chat { build :telegram_chat }

    ::BotTelegram::BenchkillerBot::Command::COMMANDS.each do |command|
      factory "#{command}_telegram_message", traits: [command]

      trait command do
        text { command == :start ? '/start' : ::BotTelegram::BenchkillerBot::BUTTONS[command] }
      end
    end
  end
end
