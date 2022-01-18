# frozen_string_literal: true

FactoryBot.define do
  factory :telegram_callback_query, class: 'Telegram::Bot::Types::CallbackQuery' do
    ::BotTelegram::BenchkillerBot::Command::COMMANDS.each do |command|
      next if command.in? [:start]

      factory "#{command}_telegram_callback_query", traits: [command]

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
