require 'rails_helper'

describe 'BotTelegram::Scenario' do
  let(:bot_record) { create :quest_bot }
  let(:headers) do
    {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'Faraday v1.5.1'
    }
  end
  let(:response) do
    {
      status: 200, body: "", headers: {}
    }
  end

  describe '/start' do
    let(:start_message) { build :telegram_message, text: '/start' }

    it 'has success response' do
      stub_request(:post, "https://api.telegram.org/bot#{bot_record.token}/sendMessage").with(
        headers: headers,
        body: {
          chat_id: start_message.chat.id,
          text: bot_record.steps.find_by(name: :start).text,
          parse_mode: 'markdown'
        }
      ).to_return(response)

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::Scenario.run start_message, bot, bot_record
      end
    end
  end
end
