RSpec.shared_context 'FindMeds Scenario 1 Success' do
  let(:search_medicine_button_message) { build :telegram_message, text: 'Поиск лекарств' }
  let(:concentration_button_message) {  }

  def push_search_medicine_button
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Убедитесь, что название написано правильно'
    }

    bot_run :find_meds, bot_record: bot_record, message: search_medicine_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end
  
  def type_existing_medicine(medicine: build(:telegram_message, text: 'Финлепсин Ретард'))
    find_meds_airtable_stub_request table: :drugs
    find_meds_airtable_stub_request table: :medicines
    find_meds_airtable_stub_request table: :companies
    find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7P'
    find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7L'

    stub = send_message_stub_request body: {
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

    bot_run :find_meds, bot_record: bot_record, message: medicine, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_company(company: build(:telegram_message, text: 'NOVARTIS FARMA, S.p.A.'))
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Какой лекарственной формулой вы пользуетесь?',
      reply_markup: reply_markup(
        [
          'Таб.пролонгированного действия'
        ],
        [
          'В начало',
          'Нужной формы нет'
        ]
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: company, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_form(form: build(:telegram_message, text: 'Таб.пролонгированного действия'))
    find_meds_airtable_stub_request table: :concentrations
    find_meds_airtable_stub_request table: :active_components

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Какая концентрация действующего вещества carbamazepine вам нужна?',
      reply_markup: reply_markup(
        [
          '400 мг',
          '100 мг'
        ],
        [
          'В начало',
          'Нужной концентрации нет'
        ]
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: form, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_concentration(concentration: build(:telegram_message, text: '400 мг'))
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Это то лекарство, которое вы используете? Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг',
      reply_markup: reply_markup(
        [
          'Да',
          'Нет'
        ]
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: concentration, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end
end
