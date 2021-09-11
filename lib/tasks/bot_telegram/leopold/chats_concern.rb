module BotTelegram::Leopold::ChatsConcern
  def exceptions
    {
      project_chat_quest_id: ::BotTelegram::Leopold::ChatDecorator::PROJECT_CHAT_QUEST_ID,
      it_way_podcast_id: ::BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    }
  end
end
