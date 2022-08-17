require 'rails_helper'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  describe 'Start' do
    let(:message) { build :start_telegram_message }

    it 'returns welcome message' do
      stub = send_message_stub_request body: {
        chat_id: chat.telegram_chat_id,
        text: 'Привет, я бот по поиску лекарств и дальше тут я рассказываю, как мной пользоваться',
        reply_markup: reply_markup([
          'Поиск лекарств', 'О проекте'
        ])
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::FindMedsBot::Scenario.new(
          message: message,
          bot: bot,
          bot_record: bot_record,
          chat: chat,
          message_object: message_object,
          user: message_object.user
        ).run
      end

      expect(stub).to have_been_requested
    end
  end 

  describe 'About' do
    let(:message) { build :start_telegram_message }
    let(:message_2) { build :telegram_message, text: 'О проекте' }

    it 'returns about message' do
      send_message_stub_request body: {
        chat_id: chat.telegram_chat_id,
        text: 'Привет, я бот по поиску лекарств и дальше тут я рассказываю, как мной пользоваться',
        reply_markup: reply_markup([
          'Поиск лекарств', 'О проекте'
        ])
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::FindMedsBot::Scenario.new(
          message: message,
          bot: bot,
          bot_record: bot_record,
          chat: chat,
          message_object: message_object,
          user: message_object.user
        ).run
      end

      stub = send_message_stub_request body: {
        chat_id: chat.telegram_chat_id,
        text: 'Здесь будет текст о проекте',
        reply_markup: reply_markup([
          'Поиск лекарств', 'О проекте'
        ])
      }

      Telegram::Bot::Client.run(bot_record.token) do |bot|
        BotTelegram::FindMedsBot::Scenario.new(
          message: message_2,
          bot: bot,
          bot_record: bot_record,
          chat: chat,
          message_object: message_object,
          user: message_object.user
        ).run
      end

      expect(stub).to have_been_requested
    end
  end

  context 'Find medicine button' do
    describe 'Medicine Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Финлепсин Ретард' }
      let(:message_3) { build :telegram_message, text: "Финлепсин Ретард \"Teva Pharmaceutical Industries, Ltd.\" carbamazepine  концентрация 400 мг" }

      it 'returns invitation to type a name' do
        airtable_stub1 = airtable_stub_request(
          base: ::BotTelegram::FindMedsBot::Tables::ApplicationTable.base_key,
          table: :names
        )

        airtable_stub2 = airtable_stub_request(
          base: ::BotTelegram::FindMedsBot::Tables::ApplicationTable.base_key,
          table: :main
        )

        stub_1 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Введите название лекарства на кириллице'
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::FindMedsBot::Scenario.new(
            message: message_1,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end

        expect(stub_1).to have_been_requested

        stub_2 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Финлепсин Ретард есть в нашей базе данных. Выберите нужную вам концентрацию',
          reply_markup: reply_markup(
            [
              "Финлепсин Ретард \"Teva Pharmaceutical Industries, Ltd.\" carbamazepine  концентрация 400 мг",
              "Финлепсин Ретард \"Teva Pharmaceutical Industries, Ltd.\" carbamazepine  концентрация 200 мг"
            ], ['Другая', 'Назад']
          )
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::FindMedsBot::Scenario.new(
            message: message_2,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end

        expect(stub_2).to have_been_requested

        stub_3 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Мы знаем об аналоге “Тегретол ЦР – carbamazepine  концентрация 200 мг – таблетки пролонгированного действия  – фирма NOVARTIS FARMA, S.p.A.”. При приёме новых лекарств, в том числе дженериков, необходимо читать их описание, так как побочные эффекты могут немного отличаться. Если вам удастся купить это лекарство или любой другой дженерик, пожалуйста, сообщите нам, эта информация может помочь другим людям. На данный момент мы не знаем, в каких странах можно купить этот препарат.',
          reply_markup: reply_markup(
            ['Назад']
          )
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::FindMedsBot::Scenario.new(
            message: message_3,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end

        expect(stub_3).to have_been_requested
        expect(airtable_stub1).to have_been_requested
        expect(airtable_stub2).to have_been_requested
      end
    end

    describe 'Medicine Not Found' do
      let(:message_1) { build :telegram_message, text: 'Поиск лекарств' }
      let(:message_2) { build :telegram_message, text: 'Валидол' }

      it 'returns invitation to type a name' do
        airtable_stub1 = airtable_stub_request(
          base: ::BotTelegram::FindMedsBot::Tables::ApplicationTable.base_key,
          table: :names
        )

        stub_1 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: 'Введите название лекарства на кириллице'
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::FindMedsBot::Scenario.new(
            message: message_1,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end

        expect(stub_1).to have_been_requested

        stub_2 = send_message_stub_request body: {
          chat_id: chat.telegram_chat_id,
          text: "#{message_2.text} отсутствует в нашей базе данных. База данных Find Meds постоянно обновляется. Попробуйте сделать такой запрос через пару недель",
          reply_markup: reply_markup([
            'Поиск лекарств', 'О проекте'
          ])
        }

        Telegram::Bot::Client.run(bot_record.token) do |bot|
          BotTelegram::FindMedsBot::Scenario.new(
            message: message_2,
            bot: bot,
            bot_record: bot_record,
            chat: chat,
            message_object: message_object,
            user: message_object.user
          ).run
        end

        expect(stub_2).to have_been_requested
        expect(airtable_stub1).to have_been_requested
      end
    end
  end
end
