module ChatQuestUlsk::Love
  class << self
    def scenario(message, game, user, bot)
      start_game_message = 'Поехали!'
      if message.text == start_game_message
        game.update current_position: 2
        message_to_user bot, ChatQuestUlsk::Message.where(quest: game.quest, position: 2).first, message
      elsif game.current_position == 1
        message_to_user bot,
          ChatQuestUlsk::Message.where(quest: game.quest, position: 1).first,
          message,
          Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [start_game_message], one_time_keyboard: true) 
      elsif expecting_answers(game)&.include? message.text
        game.update! current_position: game.current_position + 1
        next_message = ChatQuestUlsk::Message.where(quest: game.quest, position: game.current_position).first
        if next_message.present?
          message_to_user bot, next_message, message
        else
          game.finish
        end
      else
        message_to_user bot, 'Ответ неверный :( попробуй ещё раз!', message
      end
    end
  end
end
