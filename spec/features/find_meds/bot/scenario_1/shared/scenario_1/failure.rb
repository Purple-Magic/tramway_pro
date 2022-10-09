RSpec.shared_context 'FindMeds Scenario 1 Failure' do
  let(:not_existing_medicine_message) { build :telegram_message, text: 'Тегерол' }
  let(:to_beginning_button_message) { build :telegram_message, text: 'В начало' }
  let(:no_needed_company_button_message) { build :telegram_message, text: 'Нужной фирмы нет' }
  let(:no_needed_form_button_message) { build :telegram_message, text: 'Нужной формы нет' }

  def type_not_existing_medicine
    find_meds_airtable_stub_request table: :drugs

    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Увы, мы пока не знаем о таком лекарстве, позже мы добавим возможность искать и по действующим веществам, чтобы можно было найти дженерики даже если мы не знаем о том лекарстве, которое используете вы',
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: not_existing_medicine_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_not_existing_company
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Увы, у нас пока нет информации о других компаниях, выпускающих это лекарство.',
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: no_needed_company_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_not_existing_form
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Увы, у нас пока нет информации о других формах этого препарата.',
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    bot_run :find_meds, bot_record: bot_record, message: no_needed_form_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end

  def type_feedback
    stub = send_message_stub_request body: {
      chat_id: chat.telegram_chat_id,
      text: 'Мы приняли информацию!',
      reply_markup: reply_markup(
        ['В начало']
      )
    }

    feedback_id = FindMeds::Feedback.last.id + 1
    stub = send_message_stub_request(
      body: {
        chat_id: ::BotTelegram::FindMedsBot::DEVELOPER_CHAT,
        text: "Мы получили новую обратную связь от пользователя. Посмотреть её можно здесь http://purple-magic.com/admin/records/#{feedback_id}?model=FindMeds::Feedback"
      },
      current_bot: bot_leopold
    )

    bot_run :find_meds, bot_record: bot_record, message: not_existing_medicine_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
    expect(stub).to have_been_requested
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

    bot_run :find_meds, bot_record: bot_record, message: to_beginning_button_message, chat: chat, message_object: message_object

    expect(stub).to have_been_requested
  end
end
