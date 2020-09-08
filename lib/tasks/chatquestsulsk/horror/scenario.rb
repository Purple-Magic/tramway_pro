module ChatQuestUlsk::Horror
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def scenario(message, game, user, bot)
      if message.text == '/start'
        message_to_user bot, ChatQuestUlsk::Message.where(quest: game.quest, position: 1).first, message
      elsif game.present? && right_answer?(game, message.text)
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        if next_message.present?
          message_to_user bot, next_message, message
        end
        if game.current_position == 13
          sleep 5

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          game.finish
        end
      elsif !game&.finished?
        message_to_user bot, 'Ответ неверный! Попробуй ещё раз', message
      end
    end
  end
end
