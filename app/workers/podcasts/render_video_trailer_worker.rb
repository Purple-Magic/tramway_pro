# frozen_string_literal: true

class Podcasts::RenderVideoTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    render_trailer episode
    render_story_trailer episode
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def render_trailer(episode)
    output = "#{@directory}/trailer_video.mp4"
    Podcasts::Episodes::Videos::RenderTrailerService.new(episode).call
    episode.render_video_trailer_action(output, remote: false)

    Rails.logger.info 'Render trailer video completed'
  end

  def render_story_trailer(episode)
    output = "#{@directory}/story_trailer_video.mp4"
    episode.render_story_video_trailer_action(output)

    Rails.logger.info 'Render story trailer video completed'
  end
end
