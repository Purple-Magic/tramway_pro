#require 'rails_helper'
#
#describe 'BotTelegram::BenchkillerBot' do
#  describe 'Create company' do
#    let!(:bot_record) { create :benchkiller_bot }
#    let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
#    let(:message_object) { create :bot_telegram_message }
#
#    describe 'CallbackQuery' do
#      let!(:callback_query) { build :create_company_telegram_callback_query }
#
#      it 'returns success message' do
#        stub = send_message_stub_request body: {
#          chat_id: chat.telegram_chat_id,
#          text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message]
#        }
#
#        Telegram::Bot::Client.run(bot_record.token) do |bot|
#          BotTelegram::BenchkillerBot::Scenario.new(
#            callback_query,
#            bot,
#            bot_record,
#            chat,
#            message_object,
#            message_object.user
#          ).run
#        end
#
#        expect(stub).to have_been_requested
#      end
#    end
#  end
#end
