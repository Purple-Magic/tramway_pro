# frozen_string_literal: true

module BotTelegram::Info
  def user_from(sender)
    user = BotTelegram::User.active.find_or_create_by! telegram_id: sender.id
    user.update! first_name: sender.first_name,
      last_name: sender.last_name,
      username: sender.username,
      project_id: Project.find_by(title: 'PurpleMagic').id,
      telegram_id: sender.id,
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
end
