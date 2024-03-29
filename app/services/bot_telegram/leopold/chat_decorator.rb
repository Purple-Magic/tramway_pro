# frozen_string_literal: true

class BotTelegram::Leopold::ChatDecorator
  PROJECT_CHAT_QUEST_ID = '-498758668'
  IT_WAY_PODCAST_ID = '-456783051'
  STORY_MAKER_ID = '-559667872'
  DO_RE_MISSII = '-516113848'

  include BotTelegram::Leopold::ChatsConcern

  def initialize(chat)
    @chat = chat
  end

  def to_answer?
    chat_id == BotTelegram::Leopold::ItWayPro::CHAT_ID || chat_id == '-677884132'
  end

  def it_way_podcast?
    chat_id == IT_WAY_PODCAST_ID
  end

  def story_maker?
    chat_id == STORY_MAKER_ID
  end

  private

  def chat_id
    @chat.telegram_chat_id.to_s
  end
end
