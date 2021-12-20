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
    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)
  end
end
