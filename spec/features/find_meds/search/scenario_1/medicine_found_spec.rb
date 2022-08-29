# frozen_string_literal: true

require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  context 'Scenario 1' do
    describe 'Medicine Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Финлепсин Ретард' }
      let(:message_3) do
        build :telegram_message,
          text: 'Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг'
      end

      it 'returns invitation to type a name' do
        find_meds_airtable_stub_request table: :drugs
        find_meds_airtable_stub_request table: :medicines
        find_meds_airtable_stub_request table: :medicines, id: 'rec0Fqy4fYDUibmuQ'
        find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7P'
        find_meds_airtable_stub_request table: :concentrations, id: 'reccJ82ScIlm1tOxC'

        stub_1 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Введите название лекарства на кириллице'
        }

        bot_run :find_meds, bot_record: bot_record, message: message_1, chat: chat, message_object: message_object

        expect(stub_1).to have_been_requested

        stub_2 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Финлепсин Ретард есть в нашей базе данных. Выберите нужную вам концентрацию',
          reply_markup: reply_markup(
            [
              'Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг',
              'Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 200 мг'
            ], %w[Другая Назад]
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_2, chat: chat, message_object: message_object

        expect(stub_2).to have_been_requested

        stub_3 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Мы знаем об аналоге Тегретол carbamazepine концентрация 400 мг Таб.пролонгированного действия NOVARTIS FARMA, S.p.A.. При приёме новых лекарств, в том числе дженериков, необходимо читать их описание, так как побочные эффекты могут немного отличаться.Если вам удастся купить это лекарство или любой другой дженерик, пожалуйста, сообщите нам, эта информация может помочь другим людям. На данный момент мы не знаем, в каких странах можно купить этот препарат.',
          reply_markup: reply_markup(
            ['Назад']
          )
        }

        bot_run :find_meds, bot_record: bot_record, message: message_3, chat: chat, message_object: message_object

        expect(stub_3).to have_been_requested
      end
    end
  end
end
