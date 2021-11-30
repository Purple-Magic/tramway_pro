# frozen_string_literal: true

module BotTelegram::CallbacksManager
  def log_callback(callback, user, chat, bot)
    BotTelegram::Message.create! user_id: user.id, chat_id: chat.id,
      bot_id: bot.id,
      project_id: Project.find_by(title: 'PurpleMagic').id,
      options: { data: callback.data },
      message_type: :callback
  end
end
