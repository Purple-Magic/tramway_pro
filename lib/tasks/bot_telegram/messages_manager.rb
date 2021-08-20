# frozen_string_literal: true

module BotTelegram::MessagesManager
  def log_message(message, user, chat, bot, sender = :user)
    file_path = "#{Rails.root}/lib/tasks/bot_telegram/bot_message_attributes.yml"
    telegram_message_attributes = YAML.load_file(file_path)['telegram_message']['attributes']

    options = if sender == :user
                (telegram_message_attributes.reduce({}) do |hash, attribute|
                  hash.merge! attribute => message.send(attribute)
                end)
              else
                {}
              end

    BotTelegram::Message.create! text: message.try(:text), user_id: user.id, chat_id: chat.id,
      bot_id: bot.id,
      project_id: Project.find_by(title: 'PurpleMagic').id,
      sender: sender,
      options: options
  end

  def message_to_chat(bot, chat, message)
    bot.api.send_message chat_id: chat.telegram_chat_id, text: message
    user = BotTelegram::User.find_by username: chat.options['username']
    log_message message, user, chat, bot, :bot
  rescue StandardError => error
    Raven.capture_exception error
  end

  def message_to_user(bot_api, bot_record, message_obj, chat_id)
    case message_obj.class.to_s
    when 'String'
      bot_api.send_message chat_id: chat_id, text: message_obj
    when 'BotTelegram::Scenario::Step'
      if message_obj.try(:text).present?
        if message_obj.reply_markup.present?
          bot_api.send_message(
            chat_id: chat_id,
            text: message_obj&.text,
            reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(**message_obj.reply_markup),
            parse_mode: :markdown
          )
        else
          bot_api.send_message chat_id: chat_id, text: message_obj.text, parse_mode: :markdown
        end
        chat = BotTelegram::Chat.find_by telegram_chat_id: chat_id
        user = BotTelegram::User.find_by username: chat.options['username']
        log_message message_obj, user, chat, bot_record, :bot
      end
      send_file bot_api, chat_id, message_obj if message_obj.file.path.present?
    end
  rescue StandardError => error
    Raven.capture_exception error
  end

  def send_file(bot_api, chat_id, message_obj)
    mime_type = case message_obj.file.file.file[-3..].downcase
                when 'jpg', 'png'
                  [:photo, 'image/jpeg']
                when 'mp3'
                  [:voice, 'audio/mpeg']
                end
    params = {
      chat_id: chat_id,
      mime_type[0] => Faraday::UploadIO.new(message_obj.file.file.file, mime_type[1])
    }
    if message_obj.reply_markup.present?
      params.merge!(
        reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(**message_obj.reply_markup),
        parse_mode: :markdown
      )
    end

    bot_api.public_send "send_#{mime_type[0]}", **params
  end
end
