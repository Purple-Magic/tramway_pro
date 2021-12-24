# frozen_string_literal: true

class Podcasts::RenderVideoTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    render_trailer episode
    send_notification_to_chat episode.podcast.chat_id, notification(:video_trailer, :finished, file_url: episode.trailer_video.url)
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def render_trailer(episode)
    output = "#{@directory}/trailer.mp4"
    episode.render_video_trailer_action(output)

    Rails.logger.info 'Render trailer video completed'
  end
end
