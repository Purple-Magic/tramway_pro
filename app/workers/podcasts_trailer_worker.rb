# frozen_string_literal: true

class PodcastsTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    chat_id = BotTelegram::Leopold::Scenario::IT_WAY_PODCAST_ID
    episode = Podcast::Episode.find id
    send_notification_to_chat BotTelegram::Leopold::Scenario::IT_WAY_PODCAST_ID, 'Техническое сообщение. Начал рендерить аудиотрейлер.'
    episode.build_trailer
    send_notification_to_chat BotTelegram::Leopold::Scenario::IT_WAY_PODCAST_ID, 'Трейлер готов! Сейчас загружаю его в чатик. Проверьте и послушайте, норм?'
    send_file_to_chat BotTelegram::Leopold::Scenario::IT_WAY_PODCAST_ID, episode.trailer.path
  end
end
