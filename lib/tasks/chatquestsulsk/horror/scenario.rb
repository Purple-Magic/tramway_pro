module ChatQuestUlsk::Horror
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def scenario(message, game, bot)
      if message.text == '/start' && game.present?
        message_to_user bot, ChatQuestUlsk::Message.active.where(quest: game.quest, position: 1).first, message
      elsif game.present? && right_answer?(game, message.text)
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.active.where(quest: game.quest, position: game.current_position).first
        message_to_user bot, next_message, message if next_message.present?
        if game.current_position == 13
          sleep 5

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.active.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          game.finish
        end
      elsif !game&.finished?
        error_message_text = 'Ответ неверный! Попробуй ещё раз'
        message_to_user bot, error_message_text, message
        BotTelegram::Message.create! text: error_message_text
      end
    end
  end
end
