module ChatQuestUlsk::Love
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def scenario(message, game, bot)
      if message.text == '/start'
        chapter = ChatQuestUlsk::Chapter.active.find_by(quest: :love, position: 1)
        chapter.messages.order(:position).each do |bot_message|
          message_to_user bot, bot_message, message
          sleep 5
        end
      elsif game.present? && right_chapter_answer?(game, message.text)
        game.update! current_position: game.current_position + 1
        chapter = ChatQuestUlsk::Chapter.active.find_by(quest: :love, position: game.current_position)
        chapter.messages.order(:position).each do |bot_message|
          message_to_user bot, bot_message, message
          sleep 5
        end
      elsif !game&.finished?
        send_error bot, 'Ответ неверный!', message
      else
        send_error bot, 'Бот, возможно, работает не так. Напишите в чат поддержки. Подробности в описании бота', message
      end
    end
  end
end
