# frozen_string_literal: true

class BotTelegram::Leopold::ChatDecorator
  PROJECT_CHAT_QUEST_ID = '-498758668'
  IT_WAY_PODCAST_ID = '-456783051'

  include ::BotTelegram::Leopold::ChatsConcern

  def initialize(chat)
    @chat = chat
  end

  def to_answer?
    chat_id = @chat.telegram_chat_id.to_s
    # rubocop:disable Style/RedundantSelf
    (@chat.private? || chat_id == ::BotTelegram::Leopold::ItWayPro::CHAT_ID) && !exceptions.values.include?(chat_id)
    # rubocop:enable Style/RedundantSelf
  end
end
