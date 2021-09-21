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
    return if episode.full_video.present?

    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, notification(:finish, :started)
    concat_parts episode
    send_notification_to_chat chat_id, notification(:audio, :finished, file_url: episode.ready_file.url)
    render_trailer episode
    send_notification_to_chat chat_id, notification(:video_trailer, :finished, file_url: episode.trailer_video.url)
    render_full_video episode
    send_notification_to_chat chat_id, notification(:video, :finished, file_url: episode.full_video.url)
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
