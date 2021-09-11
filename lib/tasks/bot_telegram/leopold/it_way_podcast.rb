require_relative '../custom/message'

module BotTelegram::Leopold::ItWayPodcast
  include ::BotTelegram::MessagesManager

  def it_way_podcast_process(bot, chat, message, text)
    link = contains_link? text
    if link.present?
      message_obj = ::BotTelegram::Custom::Message.new(
        text: "@#{message.user.username}, привет! Мне сохранить ссылку #{link} на доску в trello для следующего новостного выпуска?"
      )
      message_to_chat bot, chat, message_obj
    end
  end

  def contains_link?(text)
    text.match /\b(?:(?:mailto:\S+|(?:https?):\/\/)?(?:\w+\.)+[a-z]{2,6})\b/
  end
end
