# frozen_string_literal: true

module BotTelegram::MessagesManager
  def log_message(message, user, chat, bot)
    file_path = "#{Rails.root}/lib/tasks/bot_telegram/bot_message_attributes.yml"
    telegram_message_attributes = YAML.load_file(file_path)['telegram_message']['attributes']

    message_object = BotTelegram::Message.find_or_create_by(
      telegram_message_id: message.message_id,
      bot_id: bot.id,
      user_id: user.id,
      chat_id: chat.id
    )

    message_object.update! text: message.try(:text),
      project_id: Project.find_by(title: 'PurpleMagic').id,
      options: (telegram_message_attributes.reduce({}) do |hash, attribute|
                  hash.merge! attribute => message.send(attribute)
                end)

    message_object
  end

  # :reek:FeatureEnvy { enabled: false }
  def message_to_chat(bot_api, chat_id, message_obj, **options)
    case message_obj.class.to_s
    when 'String'
      send_string bot_api, chat_id, message_obj, **options
    when 'BotTelegram::Custom::Message'
      bot_api.send_message chat_id: chat_id, **message_obj.options.merge(options)
      send_file bot_api, chat_id, message_obj if message_obj.file.present?
    else
      raise message_obj.class.to_s
    end
  rescue StandardError => error
    if Rails.env.production?
      Airbrake.notify error
    else
      Rails.logger.info error
    end
  end
  # :reek:FeatureEnvy { enabled: true }

  def message_to_user(bot_api, message_obj, chat_id)
    case message_obj.class.to_s
    when 'String'
      send_string bot_api, chat_id, message_obj
    when 'BotTelegram::Scenario::Step'
      send_scenario_step bot_api, chat_id, message_obj
    when 'BotTelegram::Custom::Message'
      bot_api.send_message chat_id: chat_id, **message_obj.options
    end
  rescue StandardError => error
    data = case message_obj.class.to_s
           when 'String'
             message_obj
           when 'BotTelegram::Scenario::Step', 'BotTelegram::Custom::Message'
             message_obj.attributes
           end
    if Rails.env.production?
      Airbrake.notify error, data
    else
      Rails.logger.info error
    end
  end

  def send_file(bot_api, chat_id, message_obj, **options)
    mime_type = case message_obj.file.file.file[-3..].downcase
                when 'jpg', 'png'
                  [:photo, 'image/jpeg']
                when 'mp3'
                  [:voice, 'audio/mpeg']
                when 'mp4'
                  [:video, 'video/mp4']
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

    bot_api.public_send "send_#{mime_type[0]}", **params.merge(options)
  end

  private

  def send_string(bot_api, chat_id, message_obj, **options)
    sleep 1
    bot_api.send_message(
      chat_id: chat_id,
      text: message_obj,
      **options
    )
  end

  def send_scenario_step(bot_api, chat_id, message_obj)
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
  end
end
