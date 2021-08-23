# frozen_string_literal: true

class PodcastsFinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    finish episode
  end

  private

  def finish(episode)
    chat_id = BotTelegram::Leopold::Scenario::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, 'Техническое сообщение: завершаю работу над подкастом'
    concat_parts episode
    send_notification_to_chat chat_id, "Аудио файл подкаста готов! Можно загружать на Red Circle. Файл слишком большой, поэтому прикладываю ссылку сюда. http://red-magic.ru/#{episode.ready_file.url}"
    render_trailer episode
    send_notification_to_chat chat_id, "Трейлер выпуска готов! Сейчас закину сюда. Его можно скачать и в свои соц.сетки закинуть. Файл слишком большой, поэтом прикладываю ссылку http://red-magic.ru/#{episode.trailer_video.url}"
    render_full_video episode
    send_notification_to_chat chat_id, "Полное видео готово! Его можно загружать на Youtube! Файл слишком большой, поэтом прикладываю ссылку http://red-magic.ru/#{episode.full_video.url}""
  end

  def concat_parts(episode)
    output = "#{@directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)
    Rails.logger.info 'Concatination completed'
  end

  def render_trailer(episode)
    output = "#{@directory}/trailer.mp4"
    episode.render_video_trailer(output)

    Rails.logger.info 'Render trailer video completed'
  end

  def render_full_video(episode)
    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)

    Rails.logger.info 'Render fulll video completed'
  end
end
