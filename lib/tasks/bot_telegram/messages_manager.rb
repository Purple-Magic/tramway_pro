# frozen_string_literal: true

module BotTelegram::MessagesManager
  def log_message(message, user, chat)
    file_path = "#{Rails.root}/lib/tasks/bot_telegram/bot_message_attributes.yml"
    telegram_message_attributes = YAML.load_file(file_path)['telegram_message']['attributes']
    BotTelegram::Message.create! text: message.text, user_id: user.id, chat_id: chat.id,
                                 project_id: Project.find_by(title: 'PurpleMagic').id,
                                 options: (telegram_message_attributes.reduce({}) do |hash, attribute|
                                             hash.merge! attribute => message.send(attribute)
                                           end)
  end

  def message_to_user(bot, message_obj, message_telegram)
    case message_obj.class.to_s
    when 'String'
      bot.api.send_message chat_id: message_telegram.chat.id, text: message_obj
    when 'BotTelegram::Scenario::Step'
      if message_obj.text.present?
        if message_obj.reply_markup.present?
          bot.api.send_message(
            chat_id: message_telegram.chat.id,
            text: message_obj&.text,
            reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(**message_obj.reply_markup)
          )
        else
          bot.api.send_message chat_id: message_telegram.chat.id, text: message_obj&.text
        end
      end
      if message_obj.file.path.present?
        send_file bot, message_telegram, message_obj
      end
    end
  rescue StandardError => e
    Raven.capture_exception e
  end

  def send_file(bot, message_telegram, message_obj)
    case message_obj.file.file.file[-3..-1]
    when 'jpg'
      bot.api.send_photo(
        chat_id: message_telegram.chat.id,
        photo: Faraday::UploadIO.new(message_obj.file.file.file, 'image/jpeg')
      )
    when 'mp3'
      bot.api.send_voice(
        chat_id: message_telegram.chat.id,
        voice: Faraday::UploadIO.new(message_obj.file.file.file, 'audio/mpeg')
      )
    end
  end
end
