# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::BenchkillerBot' do
  let!(:bot_record) { create_benchkiller_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }
  let!(:company) do
    user = create :benchkiller_user, telegram_user: message_object.user, password: '123'
    company_name = generate :company_name
    send_message_stub_request body: {
      chat_id: BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID,
      text: "Новая компания #{company_name}. Пользователь пока заполняет данные."
    }
    company = create :benchkiller_company, title: company_name
    company.users << user
    company.save!
    company
  end

  describe 'Commands' do
    ::BotTelegram::BenchkillerBot::Command::COMMANDS.each do |com|
      next if com.in? %i[start start_menu change_company_card create_company create_password approve_offer
                         decline_offer set_place set_regions_to_cooperate]

      describe com.to_s.capitalize.gsub('_', ' ') do
        let(:message) { build "#{com}_telegram_message" }

        it 'returns message' do
          card = ::Benchkiller::CompanyDecorator.decorate(company).bot_card

          card_stub = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: card
          }

          stubs = [card_stub]

          unless com == :get_company_card
            answer = ::BotTelegram::BenchkillerBot::ACTIONS_DATA[com][:message]

            set_com_stub = send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: answer
            }
            stubs << set_com_stub
          end

          Telegram::Bot::Client.run(bot_record.token) do |bot|
            BotTelegram::BenchkillerBot::Scenario.new(
              message: message,
              bot: bot,
              bot_record: bot_record,
              chat: chat,
              message_object: message_object,
              user: message_object.user
            ).run
          end

          stubs.each do |stub|
            expect(stub).to have_been_requested
          end
        end
      end

      next if com == :get_company_card

      describe "Full #{com.to_s.capitalize.gsub('_', ' ')}" do
        let(:message) { build "#{com}_telegram_message" }
        let!(:attribute_name) { com.to_s.gsub('set_', '') }
        let!(:argument) do
          attributes = attributes_for :benchkiller_company
          if com == :set_company_name
            attributes[:title]
          else
            attributes[:data][attribute_name.to_sym]
          end
        end

        describe 'Success' do
          let!(:telegram_message) { build :telegram_message, text: argument }

          it 'returns success messages' do
            send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: ::Benchkiller::CompanyDecorator.decorate(company).bot_card
            }

            send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[com][:message]
            }

            Telegram::Bot::Client.run(bot_record.token) do |bot|
              BotTelegram::BenchkillerBot::Scenario.new(
                message: message,
                bot: bot,
                bot_record: bot_record,
                chat: chat,
                message_object: message_object,
                user: message_object.user
              ).run
            end

            message = case com
                      when :set_company_name
                        benchkiller_i18n_scope(com, :success, old_company_name: company.title, company_name: argument)
                      else
                        benchkiller_i18n_scope(com, :success, attribute_name.to_sym => argument)
                      end

            stub = send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: message
            }

            Telegram::Bot::Client.run(bot_record.token) do |bot|
              BotTelegram::BenchkillerBot::Scenario.new(
                message: telegram_message,
                bot: bot,
                bot_record: bot_record,
                chat: chat,
                message_object: message_object,
                user: message_object.user
              ).run
            end

            expect(stub).to have_been_requested
          end

          it 'sets attribute' do
            send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: ::Benchkiller::CompanyDecorator.decorate(company).bot_card
            }

            send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[com][:message]
            }

            Telegram::Bot::Client.run(bot_record.token) do |bot|
              BotTelegram::BenchkillerBot::Scenario.new(
                message: message,
                bot: bot,
                bot_record: bot_record,
                chat: chat,
                message_object: message_object,
                user: message_object.user
              ).run
            end

            message = case com
                      when :set_company_name
                        benchkiller_i18n_scope(com, :success, old_company_name: company.title, company_name: argument)
                      else
                        benchkiller_i18n_scope(com, :success, attribute_name.to_sym => argument)
                      end

            send_message_stub_request body: {
              chat_id: chat.telegram_chat_id,
              text: message
            }

            Telegram::Bot::Client.run(bot_record.token) do |bot|
              BotTelegram::BenchkillerBot::Scenario.new(
                message: telegram_message,
                bot: bot,
                bot_record: bot_record,
                chat: chat,
                message_object: message_object,
                user: message_object.user
              ).run
            end

            company.reload
            if com == :set_company_name
              expect(company.title).to eq argument
            else
              expect(company.public_send(attribute_name)).to eq argument
            end
          end
        end

        unless com.in? [:set_company_name]
          describe 'Failure' do
            let!(:telegram_message) do
              t = com.in?(%i[set_regions_to_cooperate set_phone]) ? '' : 'fail_argument'
              build :telegram_message, text: t
            end

            before do
              company_name = generate :company_name
              send_message_stub_request body: {
                chat_id: BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID,
                text: "Новая компания #{company_name}. Пользователь пока заполняет данные."
              }
              create :benchkiller_company, title: company_name
            end

            it 'returns error messages' do
              send_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: ::Benchkiller::CompanyDecorator.decorate(company).bot_card
              }

              send_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[com][:message]
              }

              Telegram::Bot::Client.run(bot_record.token) do |bot|
                BotTelegram::BenchkillerBot::Scenario.new(
                  message: message,
                  bot: bot,
                  bot_record: bot_record,
                  chat: chat,
                  message_object: message_object,
                  user: message_object.user
                ).run
              end

              message = benchkiller_i18n_scope(com, :failure, attribute_name.to_sym => argument)

              stub = send_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: message
              }

              Telegram::Bot::Client.run(bot_record.token) do |bot|
                BotTelegram::BenchkillerBot::Scenario.new(
                  message: telegram_message,
                  bot: bot,
                  bot_record: bot_record,
                  chat: chat,
                  message_object: message_object,
                  user: message_object.user
                ).run
              end

              expect(stub).to have_been_requested
            end

            it 'does not set attribute' do
              send_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: ::Benchkiller::CompanyDecorator.decorate(company).bot_card
              }

              send_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[com][:message]
              }

              Telegram::Bot::Client.run(bot_record.token) do |bot|
                BotTelegram::BenchkillerBot::Scenario.new(
                  message: message,
                  bot: bot,
                  bot_record: bot_record,
                  chat: chat,
                  message_object: message_object,
                  user: message_object.user
                ).run
              end

              message = case com
                        when :set_company_name
                          benchkiller_i18n_scope(com, :failure, old_company_name: company.title, company_name: argument)
                        else
                          benchkiller_i18n_scope(com, :failure, attribute_name.to_sym => argument)
                        end

              send_message_stub_request body: {
                chat_id: chat.telegram_chat_id,
                text: message
              }

              Telegram::Bot::Client.run(bot_record.token) do |bot|
                BotTelegram::BenchkillerBot::Scenario.new(
                  message: telegram_message,
                  bot: bot,
                  bot_record: bot_record,
                  chat: chat,
                  message_object: message_object,
                  user: message_object.user
                ).run
              end

              company.reload
              if com == :set_company_name
                expect(company.title).not_to eq argument
              else
                expect(company.public_send(attribute_name)).not_to eq argument
              end
            end
          end
        end
      end
    end
  end
end
