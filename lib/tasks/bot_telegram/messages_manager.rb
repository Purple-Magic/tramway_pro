# frozen_string_literal: true

module BotTelegram::MessagesManager
  def log_message(message, user, chat, bot)
    file_path = "#{Rails.root}/lib/tasks/bot_telegram/bot_message_attributes.yml"
    telegram_message_attributes = YAML.load_file(file_path)['telegram_message']['attributes']

    BotTelegram::Message.create! text: message.try(:text), user_id: user.id, chat_id: chat.id,
      bot_id: bot.id,
      project_id: Project.find_by(title: 'PurpleMagic').id,
      options: (telegram_message_attributes.reduce({}) do |hash, attribute|
                  hash.merge! attribute => message.send(attribute)
                end)
  end

  # :reek:FeatureEnvy { enabled: false }
  def message_to_chat(bot, chat, message_obj)
    bot_api = bot.api
    case message_obj.class.to_s
    when 'String'
      bot_api.send_message chat_id: chat.telegram_chat_id, text: message_obj
    when 'BotTelegram::Custom::Message'
      bot_api.send_message chat_id: chat.telegram_chat_id, **message_obj.options.merge(parse_mode: :markdown)
      send_file bot_api, chat_id, message_obj if message_obj.file.present?
    else
      raise message_obj.class.to_s
    end
  rescue StandardError => error
    Airbrake.notify error
  end
  # :reek:FeatureEnvy { enabled: true }

  def message_to_user(bot_api, message_obj, chat_id)
    case message_obj.class.to_s
    when 'String'
      sleep 1
      bot_api.send_message(
        chat_id: chat_id,
        text: message_obj,
        parse_mode: :markdown
      )
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
      end
      send_file bot_api, chat_id, message_obj if message_obj.file.path.present?
    when 'BotTelegram::Custom::Message'
      bot_api.send_message chat_id: chat_id, **message_obj.options
    end
  rescue StandardError => error
    Airbrake.notify error
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
