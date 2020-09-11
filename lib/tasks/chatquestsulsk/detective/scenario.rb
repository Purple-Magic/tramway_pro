module ChatQuestUlsk::Detective
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def scenario(message, game, user, bot)
      if game&.current_position == 1 
        message_to_user bot, ChatQuestUlsk::Message.where(quest: game.quest, position: 1).first, message

        sleep 5

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        message_to_user bot, next_message, message

        sleep 10

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        message_to_user bot, next_message, message

        sleep 3

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        message_to_user bot, next_message, message
      elsif game.present? && right_answer?(game, message.text)
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        if next_message.present?
          message_to_user bot, next_message, message
        else
          game.finish
        end

        case game.current_position
        when 6
          sleep 5

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message
        when 8
          sleep 10

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          sleep 20

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message
        when 16
          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message
        when 19
          sleep 30

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          sleep 5

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
          message_to_user bot, next_message, message

          game.finish
        end
      elsif !game&.finished?
        error_message_text = 'Ответ неверный! Я сегодня добрый, так что попробуй ещё раз!'
        message_to_user bot, error_message_text, message
        BotTelegram::Message.create! text: error_message_text
      end
    end
  end
end
