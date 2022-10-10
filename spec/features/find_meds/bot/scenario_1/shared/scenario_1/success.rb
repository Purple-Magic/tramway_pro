# frozen_string_literal: true

RSpec.shared_context 'FindMeds Scenario 1 Success' do
  let(:search_medicine_button_message) { build :telegram_message, text: 'Поиск лекарств' }
  let(:yes_button_message) { build :telegram_message, text: 'Да' }
  let(:bot_helped_me_button_message) { build :telegram_message, text: 'Бот мне помог!' }

  def push_search_medicine_button
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Убедитесь, что название написано правильно'
    }

    bot_run :find_meds, bot_record: bot_record, message: search_medicine_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_medicine(medicine: nil, companies: nil)
    medicine ||= 'Финлепсин Ретард'
    medicine_button_message = build(:telegram_message, text: medicine)
    companies ||= ['NOVARTIS FARMA, S.p.A.', 'МОСКОВСКИЙ ЭНДОКРИННЫЙ ЗАВОД, ФГУП']

    find_meds_airtable_stub_request table: :drugs
    find_meds_airtable_stub_request table: :medicines
    find_meds_airtable_stub_request table: :companies
    find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7P'
    find_meds_airtable_stub_request table: :companies, id: 'receQeH2nuPmxUA7L'

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Мы нашли лекараство. Лекарством какой фирмы вы пользуетесь?',
      reply_markup: reply_markup(
        companies,
        ['В начало', 'Нужной фирмы нет']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: medicine_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_company(company: nil, forms: nil)
    company ||= 'NOVARTIS FARMA, S.p.A.'
    company_button_message = build(:telegram_message, text: company)

    forms ||= ['Таб.пролонгированного действия']

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Какой лекарственной формулой вы пользуетесь?',
      reply_markup: reply_markup(
        forms,
        ['В начало', 'Нужной формы нет']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: company_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_form(form: nil, component: nil, concentrations: nil)
    form ||= 'Таб.пролонгированного действия'
    form_button_message = build(:telegram_message, text: form)

    component ||= 'carbamazepine'

    concentrations ||= ['400 мг', '100 мг']

    find_meds_airtable_stub_request table: :concentrations
    find_meds_airtable_stub_request table: :components

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: "Какая концентрация действующего вещества #{component} вам нужна?",
      reply_markup: reply_markup(
        *concentrations,
        ['В начало', 'Нужной концентрации нет']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: form_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_concentration(concentration: nil, medicine: nil)
    concentration ||= '400 мг'
    concentration_button_message = build(:telegram_message, text: concentration)

    medicine ||= 'Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг'

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: "Это то лекарство, которое вы используете? #{medicine}",
      reply_markup: reply_markup(%w[Да Нет])
    }

    bot_run :find_meds, bot_record: bot_record, message: concentration_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def push_yes_button_on_reinforcement(medicines: nil)
    medicines ||= ['Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг']
    list = medicines.map do |medicine|
      "🔵 #{medicine}"
    end.join("\n")
    text = "Мы нашли следующие лекарства, совпадающие с вашим по действующему веществу, форме и концентрации\n#{list}"
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: text,
      reply_markup: reply_markup(
        ['Бот мне помог!'], ['Это не совсем та информация, на которую я надеялся_ась (отправить отзыв)']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: yes_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def push_bot_helped_me_on_last_step
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Поздравляем вас!',
      reply_markup: reply_markup(['В начало'])
    }

    bot_run :find_meds, bot_record: bot_record, message: bot_helped_me_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end
end
