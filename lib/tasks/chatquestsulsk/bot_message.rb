module ChatQuestUlsk::BotMessage
  def log_message(message, user, chat)
    BotTelegram::Message.create! text: message.text, user_id: user.id, chat_id: chat.id,
                                 options: (%i[animation audio author_signature caption caption_entities channel_chat_created
                                              connected_website contact caption_entities channel_chat_created connected_website
                                              contact date delete_chat_photo document edit_date forward_date forward_from
                                              forward_from_chat forward_from_message_id forward_sender_name forward_signature game
                                              group_chat_created invoice left_chat_member location media_group_id message_id
                                              migrate_from_chat_id migrate_to_chat_id new_chat_members new_chat_photo new_chat_title
                                              passport_data photo pinned_message poll reply_markup reply_to_message sticker
                                              successful_payment supergroup_chat_created venue video video_note voice].reduce({}) do |hash, attribute|
                                             hash.merge! attribute => message.send(attribute)
                                           end)
  end

  def message_to_user(bot, message_obj, message_telegram, reply_markup = nil)
    case message_obj.class.to_s
    when 'String'
      bot.api.send_message chat_id: message_telegram.chat.id, text: message_obj
    when 'ChatQuestUlsk::Message'
      if message_obj.text.present?
        if reply_markup
          bot.api.send_message chat_id: message_telegram.chat.id, text: message_obj&.text, reply_markup: reply_markup
        else
          bot.api.send_message chat_id: message_telegram.chat.id, text: message_obj&.text
        end
      end
      if message_obj.file.present?
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
  end
end
