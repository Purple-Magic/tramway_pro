# frozen_string_literal: true

class PodcastsRenderVideoWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify
  include PodcastsWorkerConcern

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    render_video episode
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def render_video(episode)
    return if episode.full_video.present?

    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    render_full_video episode
    send_notification_to_chat chat_id, notification(:video, :finished, file_url: episode.full_video.url)
  end
end
