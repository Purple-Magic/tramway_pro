require 'rails_helper'

describe 'BotTelegram::Scenario' do
  let(:message) { build :telegram_message }
  let(:bot_record) { build :bot }

  describe '/start' do
    it 'has success response' do
      stub_request(:any, 'https://api.telegram.org')

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::Scenario.run message, bot, bot_record
      end
    end
  end
end
