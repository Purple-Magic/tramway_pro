# frozen_string_literal: true

class Podcasts::RenderVideoWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

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
    render_full_video episode
    send_notification_to_chat episode.podcast.chat_id, notification(:video, :finished, file_url: episode.full_video.url)
  end

  def render_full_video(episode)
    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)

    Rails.logger.info 'Render full video completed'
  end
end
