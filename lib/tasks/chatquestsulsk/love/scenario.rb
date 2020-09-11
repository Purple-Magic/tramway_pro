module ChatQuestUlsk::Love
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def scenario(message, game, user, bot)
      start_game_message = 'Поехали!'
      if message.text == start_game_message && game.present?
        game.update current_position: 2
        message_to_user bot, ChatQuestUlsk::Message.where(quest: game.quest, position: 2).first, message
      elsif game&.current_position == 1
        message_to_user bot,
          ChatQuestUlsk::Message.where(quest: game.quest, position: 1).first,
          message,
          Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [start_game_message], one_time_keyboard: true)
      elsif game.present? && right_answer?(game, message.text)
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        if next_message.present?
          message_to_user bot, next_message, message
          if game.current_position == 10
            sleep 5
            game.update! current_position: game.current_position + 1
            next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
            message_to_user bot, next_message, message
            game.finish
          end
        end
      elsif !game&.finished?
        error_message_text = 'Ответ неверный :( попробуй ещё раз!'
        message_to_user bot, error_message_text, message
        BotTelegram::Message.create! text: error_message_text
      end
    end
  end
end
