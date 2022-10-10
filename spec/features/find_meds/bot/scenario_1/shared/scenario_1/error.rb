RSpec.shared_context 'FindMeds Scenario 1 Error' do
  def type_existing_company_for_medicine_without_forms(company:)
    company ||= 'BAYER, AG'
    company_button_message = build :telegram_message, text: company

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Увы, у нас пока нет информации о других формах этого препарата.',
      reply_markup: reply_markup(['В начало'])
    }

    bot_run :find_meds, bot_record: bot_record, message: company_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end
end
