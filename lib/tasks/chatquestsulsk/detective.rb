module ChatQuestUlsk::Detective
  class << self
    def scenario(message, game, _user, bot)
      if game.current_position == 1
        message_to_user bot, ChatQuestUlsk::Message.where(area: game.area, position: 1).first, message

        sleep 5

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        message_to_user bot, next_message, message

        sleep 10

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        message_to_user bot, next_message, message

        sleep 3

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        message_to_user bot, next_message, message
      elsif expecting_answers(game)&.include? message.text
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        if next_message.present?
          message_to_user bot, next_message, message
        else
          game.finish
        end

        case game.current_position
        when 6
          sleep 5

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message
        when 8
          sleep 10

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message

          sleep 20

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message
        when 16
          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message
        when 19
          sleep 30

          message_to_user bot, 'тут ещё звук', message
        end
      end
    end
  end
end
