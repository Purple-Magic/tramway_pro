# frozen_string_literal: true

module BotTelegram::Info
  def user_from(message)
    user = BotTelegram::User.active.find_or_create_by! telegram_id: message.from.id
    user.update! first_name: message.from.first_name,
                 last_name: message.from.last_name,
                 username: message.from.username,
                 project_id: Project.find_by(title: 'PurpleMagic').id,
                 telegram_id: message.from.id,
                 options: {
                   can_join_groups: message.from.can_join_groups,
                   can_read_all_group_messages: message.from.can_read_all_group_messages,
                   language_code: message.from.language_code,
                   supports_inline_queries: message.from.supports_inline_queries,
                   is_bot: message.from.is_bot
                 }
    user.reload
  end

  def chat_from(message)
    chat = BotTelegram::Chat.active.find_or_create_by! telegram_chat_id: message.chat.id
    chat.update! title: message.chat.title,
                 chat_type: message.chat.type,
                 project_id: Project.find_by(title: 'PurpleMagic').id,
                 options: (%i[
                   all_members_are_administrators can_set_sticker_set description first_name invite_link
                   last_name permissions photo pinned_message slow_mode_delay sticker_set_name
                   username
                 ].reduce({}) do |hash, attribute|
                             hash.merge! attribute => message.chat.send(attribute)
                           end)
    chat.reload
  end
end
