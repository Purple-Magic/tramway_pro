require 'rails_helper'

describe 'BotTelegram::BenchkillerBot' do
  describe 'Unregistered user' do
    let!(:bot_record) { create :benchkiller_bot }
    let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
    let(:message_object) { create :bot_telegram_message }
    let!(:company) do
      user = create :benchkiller_user, telegram_user: message_object.user, password: '123'
      company = create :benchkiller_company
      company.users << user
      company.save!
      company
    end

    before  do
    end

    describe 'Callback queries' do
      ::BotTelegram::BenchkillerBot::Command::COMMANDS.each do |command|
        unless command.in? [ :start, :create_password, :approve_offer, :decline_offer ]
          describe command.to_s.capitalize.gsub('_', ' ') do
            let(:callback_query) { build "#{command}_telegram_callback_query" }

            it 'returns message' do
              card = ::Benchkiller::CompanyDecorator.decorate(company).bot_card

              card_stub = send_markdown_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: card
              }

              stubs = [ card_stub ]

              unless command == :get_company_card
                message = ::BotTelegram::BenchkillerBot::ACTIONS_DATA[command][:message]

                set_command_stub = send_markdown_message_stub_request body: {
                  chat_id: chat.telegram_chat_id,
                  text: message
                }
                stubs << set_command_stub
              end

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

              stubs.each do |stub|
                expect(stub).to have_been_requested
              end
            end
          end

          unless command == :get_company_card
            describe "Full #{command.to_s.capitalize.gsub('_', ' ')}" do
              let(:callback_query) { build "#{command}_telegram_callback_query" }
              let!(:attribute_name) { command.to_s.gsub('set_', '') }
              let!(:argument) do
                attributes = attributes_for :benchkiller_company
                if command == :set_company_name
                  attributes[:title]
                else
                  attributes[:data][attribute_name.to_sym]
                end
              end
              let!(:telegram_message) { build :telegram_message, text: argument }

              it 'sets attribute' do
                send_markdown_message_stub_request body: {
                  chat_id: chat.telegram_chat_id,
                  text: ::Benchkiller::CompanyDecorator.decorate(company).bot_card
                }

                send_markdown_message_stub_request body: {
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

                  message = case command
                            when :set_company_name
                              benchkiller_i18n_scope(command, :success, old_company_name: company.title, company_name: argument)
                            else
                              benchkiller_i18n_scope(command, :success, attribute_name.to_sym => argument)
                            end

                  stub = send_markdown_message_stub_request body: {
                    chat_id: chat.telegram_chat_id,
                    text: message
                  }

                  Telegram::Bot::Client.run(bot_record.token) do |bot|
                    BotTelegram::BenchkillerBot::Scenario.new(
                      telegram_message, 
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
    end
  end
end
