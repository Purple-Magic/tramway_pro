module BotTelegram::UsersState
  def set_state_for(state, user:, bot:, data: nil)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot.id,
      current_state: state,
      data: data
  end
end
