# frozen_string_literal: true

RSpec.shared_context 'FindMeds Scenario 1 Failure' do
  let(:not_existing_medicine_message) { build :telegram_message, text: 'Тегерол' }
  let(:to_beginning_button_message) { build :telegram_message, text: 'В начало' }
  let(:no_needed_company_button_message) { build :telegram_message, text: 'Нужного производителя нет' }
  let(:no_needed_form_button_message) { build :telegram_message, text: 'Нужной формы нет' }
  let(:no_needed_concentration_button_message) { build :telegram_message, text: 'Нужной концентрации нет' }
  let(:no_button_message) { build :telegram_message, text: 'Нет' }
  let(:its_not_what_i_wanted_message) do
    build :telegram_message, text: 'Это не совсем та информация, на которую я надеялся_ась (отправить отзыв)'
  end

  def type_not_existing_medicine
    find_meds_airtable_stub_request table: :drugs

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.not_found'),
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: not_existing_medicine_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_not_existing_company
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.company_not_found'),
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: no_needed_company_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_not_existing_form
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.form_not_found'),
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: no_needed_form_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_not_existing_concentration
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.concentration_not_found'),
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: no_needed_concentration_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_feedback
    we_got_it_message_stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.we_got_it'),
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    feedback_id = FindMeds::Feedback.last.id + 1
    notification_stub = send_message_stub_request(
      body: {
        chat_id: ::BotTelegram::FindMedsBot::DEVELOPER_CHAT,
        text: I18n.t('find_meds.bot.notifications.new_feedback', id: feedback_id)
      },
      current_bot: bot_leopold
    )

    bot_run :find_meds, bot_record: bot_record, message: not_existing_medicine_message, chat: chat,
message_object: message_object

    expect(we_got_it_message_stub).to have_been_requested
    expect(notification_stub).to have_been_requested
    expect(FindMeds::Feedback.last.text).to eq not_existing_medicine_message.text
  end

  def push_to_beginning_button
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Выберите следующее действие',
      reply_markup: reply_markup([
                                   'Поиск лекарств', 'О проекте'
                                 ])
    }

    bot_run :find_meds, bot_record: bot_record, message: to_beginning_button_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end

  def push_no_button_on_reinforcement
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.unfortunately_we_do_not_have_more_info'),
      reply_markup: reply_markup(['В начало'])
    }

    bot_run :find_meds, bot_record: bot_record, message: no_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def push_bot_didnt_help_me_on_last_step
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: I18n.t('find_meds.bot.find_medicine.please_type_info_about_medicine'),
      reply_markup: reply_markup(['В начало'])
    }

    bot_run :find_meds, bot_record: bot_record, message: its_not_what_i_wanted_message, chat: chat,
message_object: message_object

    expect(stub).to have_been_requested
  end
end
