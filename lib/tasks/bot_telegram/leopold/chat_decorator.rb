# frozen_string_literal: true

class BotTelegram::Leopold::ChatDecorator
  PROJECT_CHAT_QUEST_ID = '-498758668'
  IT_WAY_PODCAST_ID = '-456783051'

  def initialize(chat)
    @chat = chat
  end

  def to_answer?
    chat_id = @chat.telegram_chat_id.to_s
    (@chat.private? || chat_id == ::BotTelegram::Leopold::ItWayPro::CHAT_ID) && !self.exceptions.values.include?(chat_id)
  end

  class << self
    def exceptions
      {
        project_chat_quest_id: PROJECT_CHAT_QUEST_ID,
        it_way_podcast_id: IT_WAY_PODCAST_ID
      }
    end
  end
end
