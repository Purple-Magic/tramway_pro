# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }
  before do
    create :find_meds_feedback
  end

  context 'Scenario 1' do
    describe 'Company Not Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Финлепсин Ретард' }
      let(:message_3) { build :telegram_message, text: 'Нужной фирмы нет' }
      let(:message_4) { build :telegram_message, text: 'NOVARTIS FARMA, S.p.A.' }
      let(:message_5) { build :telegram_message, text: 'В начало' }

      context 'Saving feedback' do
        let!(:bot_leopold) { create :leopold_bot }

        it 'returns not found message' do
          find_meds_airtable_stub_request table: :drugs
          find_meds_airtable_stub_request table: :medicines
          find_meds_airtable_stub_request table: :companies
          find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7P'
          find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7L'

          stub_1 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Убедитесь, что название написано правильно'
          }

          bot_run :find_meds, bot_record: bot_record, message: message_1, chat: chat, message_object: message_object

          expect(stub_1).to have_been_requested

          stub_2 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Мы нашли лекараство. Лекарством какой фирмы вы пользуетесь?',
            reply_markup: reply_markup(
              [
                'NOVARTIS FARMA, S.p.A.',
                'МОСКОВСКИЙ ЭНДОКРИННЫЙ ЗАВОД, ФГУП'
              ],
              [
                'В начало',
                'Нужной фирмы нет'
              ]
            )
          }

          bot_run :find_meds, bot_record: bot_record, message: message_2, chat: chat, message_object: message_object

          expect(stub_2).to have_been_requested

          stub_3 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Увы, у нас пока нет информации о других компаниях, выпускающих это лекарство.',
            reply_markup: reply_markup(
              ['В начало']
            )
          }

          bot_run :find_meds, bot_record: bot_record, message: message_3, chat: chat, message_object: message_object

          expect(stub_3).to have_been_requested

          stub_4 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Мы приняли информацию!',
            reply_markup: reply_markup(
              ['В начало']
            )
          }

          feedback_id = FindMeds::Feedback.last.id + 1
          stub_5 = send_message_stub_request(
            body: {
              chat_id: ::BotTelegram::FindMedsBot::DEVELOPER_CHAT,
              text: "Мы получили новую обратную связь от пользователя. Посмотреть её можно здесь http://purple-magic.com/admin/records/#{feedback_id}?model=FindMeds::Feedback"
            },
            current_bot: bot_leopold
          )

          bot_run :find_meds, bot_record: bot_record, message: message_4, chat: chat, message_object: message_object

          expect(stub_4).to have_been_requested
          expect(stub_5).to have_been_requested
          expect(FindMeds::Feedback.last.text).to eq message_4.text
        end
      end

      context 'Returning to the beginning' do
        it 'returns the start message' do
          find_meds_airtable_stub_request table: :drugs
          find_meds_airtable_stub_request table: :medicines
          find_meds_airtable_stub_request table: :companies
          find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7P'
          find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7L'

          stub_1 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Убедитесь, что название написано правильно'
          }

          bot_run :find_meds, bot_record: bot_record, message: message_1, chat: chat, message_object: message_object

          expect(stub_1).to have_been_requested

          stub_2 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Мы нашли лекараство. Лекарством какой фирмы вы пользуетесь?',
            reply_markup: reply_markup(
              [
                'NOVARTIS FARMA, S.p.A.',
                'МОСКОВСКИЙ ЭНДОКРИННЫЙ ЗАВОД, ФГУП'
              ],
              [
                'В начало',
                'Нужной фирмы нет'
              ]
            )
          }

          bot_run :find_meds, bot_record: bot_record, message: message_2, chat: chat, message_object: message_object

          expect(stub_2).to have_been_requested

          stub_3 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Увы, у нас пока нет информации о других компаниях, выпускающих это лекарство.',
            reply_markup: reply_markup(
              ['В начало']
            )
          }

          bot_run :find_meds, bot_record: bot_record, message: message_3, chat: chat, message_object: message_object

          expect(stub_2).to have_been_requested


          stub_3 = send_message_stub_request body: {
            chat_id: chat.telegram_chat_id,
            text: 'Выберите следующее действие',
            reply_markup: reply_markup([
              'Поиск лекарств', 'О проекте'
            ])
          }

          bot_run :find_meds, bot_record: bot_record, message: message_5, chat: chat, message_object: message_object

          expect(stub_3).to have_been_requested
        end
      end
    end
  end
end
