module ChatQuestUlsk::AfterSvyagaAreaQuest
  class << self
    def scenario(message, game, user, bot)
      if game.current_position == 1 
        bot.api.send_message(
          chat_id: message.chat.id,
          text: ChatQuestUlsk::Message.where(area: game.area, position: 1).first&.text
        )

        sleep 5

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        bot.api.send_message chat_id: message.chat.id, text: next_message.text

        sleep 10

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        bot.api.send_message chat_id: message.chat.id, text: next_message.text

        sleep 3

        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        bot.api.send_message chat_id: message.chat.id, text: next_message.text
      elsif expecting_answers(game)&.include? message.text
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first
        bot.api.send_message chat_id: message.chat.id, text: next_message.text
      end
    end
  end
end
