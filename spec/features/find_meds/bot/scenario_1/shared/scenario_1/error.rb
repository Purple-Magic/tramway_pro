RSpec.shared_context 'FindMeds Scenario 1 Error' do
  def type_existing_company_for_medicine_without_forms(company:)
    company ||= 'BAYER, AG'
    company_button_message = build :telegram_message, text: company

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: "Увы, у нас пока нет информации о формах этого препарата. Мы будем вам благодарны, если вы введёте информацию о том лекарстве, которое вы искали (по возможности, введите название, компанию, действующее вещество и концентрацию)",
      reply_markup: reply_markup(['В начало'])
    }

    bot_run :find_meds, bot_record: bot_record, message: company_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_existing_form_for_medicine_with_two_or_more_components(form:)
    form ||= 'Таблетка'
    form_button_message = build(:telegram_message, text: form)

    find_meds_airtable_stub_request table: :concentrations
    find_meds_airtable_stub_request table: :active_components

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'У этого лекарства более одного действующего вещества, пока что бот не умеет работать с такими лекарствами. Напишите комментарий в свободной форме, что вы хотели найти.',
      reply_markup: reply_markup([ 'В начало' ])
    }

    bot_run :find_meds, bot_record: bot_record, message: form_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end
end
