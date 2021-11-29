# frozen_string_literal: true

module BotTelegram::Info
  def user_from(sender)
    user = BotTelegram::User.active.find_or_create_by! telegram_id: sender.id, username: sender.username
    user.update! first_name: sender.first_name,
      last_name: sender.last_name,
      project_id: Project.find_by(title: 'PurpleMagic').id,
      options: {
        can_join_groups: sender.can_join_groups,
        can_read_all_group_messages: sender.can_read_all_group_messages,
        language_code: sender.language_code,
        supports_inline_queries: sender.supports_inline_queries,
        is_bot: sender.is_bot
      }
    user.reload
  end

  def chat_from(message_chat)
    chat = BotTelegram::Chat.active.find_or_create_by! telegram_chat_id: message_chat.id
    chat.update! title: message_chat.title,
      chat_type: message_chat.type,
      project_id: Project.find_by(title: 'PurpleMagic').id,
      options: (%i[
        all_members_are_administrators can_set_sticker_set description first_name invite_link
        last_name permissions photo pinned_message slow_mode_delay sticker_set_name
        username
      ].reduce({}) do |hash, attribute|
                  hash.merge! attribute => message_chat.send(attribute)
                end)
    chat.reload
  end

  def channel_from(channel, bot_record)
    channel_record = BotTelegram::Channel.active.find_or_create_by! telegram_channel_id: channel.id
    channel_record.update! title: channel.title,
      bot_id: bot_record.id,
      project_id: Project.find_by(title: 'PurpleMagic').id
    channel_record.reload
  end
end
