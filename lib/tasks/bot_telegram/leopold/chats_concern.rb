# frozen_string_literal: true

module BotTelegram::Leopold::ChatsConcern
  def exceptions
    {
      project_chat_quest_id: ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID,
      it_way_podcast_id: ::BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID,
      story_maker_id: ::BotTelegram::Leopold::ChatDecorator::STORY_MAKER_ID,
      do_re_missii_id: ::BotTelegram::Leopold::ChatDecorator::DO_RE_MISSII
    }
  end
end
