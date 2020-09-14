module ChatQuestUlsk::Detective
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def scenario(message, game, _user, bot)
      if message.text == '/start'
        chapter = ChatQuestUlsk::Chapter.active.find_by(quest: :detective, position: 1)
        chapter.messages.order(:position).each do |bot_message|
          message_to_user bot, bot_message, message
          sleep 5
        end
      elsif game.present? && right_chapter_answer?(game, message.text)
        game.update! current_position: game.current_position + 1
        chapter = ChatQuestUlsk::Chapter.active.find_by(quest: :detective, position: game.current_position)
        chapter.messages.order(:position).each do |bot_message|
          message_to_user bot, bot_message, message
          sleep 5
        end
      elsif !game&.finished?
        error_message_text = 'Ответ неверный! Я сегодня добрый, так что попробуй ещё раз!'
        message_to_user bot, error_message_text, message
        BotTelegram::Message.create! text: error_message_text
      end
    end
  end
end
