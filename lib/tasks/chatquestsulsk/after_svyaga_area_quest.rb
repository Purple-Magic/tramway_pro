module ChatQuestUlsk::AfterSvyagaAreaQuest
  class << self
    def scenario(message, game, user, bot)
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
        message_to_user next_message, message
      elsif expecting_answers(game)&.include? message.text
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        message_to_user bot, next_message, message
        
        case game.current_position
        when 6
          sleep 5

          game.update! current_position: game.current_position + 1
          next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
          message_to_user bot, next_message, message
        when 8
          
        end
      end
    end
  end
end
