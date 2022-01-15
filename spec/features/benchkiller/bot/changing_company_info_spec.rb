require 'rails_helper'

describe 'BotTelegram::BenchkillerBot' do
  describe 'Unregistered user' do
    let!(:bot_record) { create :benchkiller_bot }
    let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
    let(:message_object) { create :bot_telegram_message }

    ::BotTelegram::BenchkillerBot::Command::COMMANDS.each do |command|
      unless command.in? [ :start, :get_company_card, :create_password, :approve_offer, :decline_offer ]
        describe command.to_s.capitalize.gsub('_', ' ') do
          let(:callback_query) { build "#{command}_telegram_callback_query" }

          it 'returns message' do
            stub = send_markdown_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[command][:message]
            }

            Telegram::Bot::Client.run(bot_record.token) do |bot|
              BotTelegram::BenchkillerBot::Scenario.new(
                callback_query,
                bot,
                bot_record,
                chat,
                message_object,
                message_object.user
              ).run
            end

            expect(stub).to have_been_requested
          end
        end
      end
    end
  end
end
