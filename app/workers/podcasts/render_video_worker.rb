# frozen_string_literal: true

class Podcasts::RenderVideoWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    raise [Podcast::Episode.pluck(&:id).join(','), id].join(',')
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    render_video episode
  rescue StandardError => error
    show error
  end

  private

  def render_video(episode)
    raise 'You should add episode cover to episode' unless episode.cover.present?

    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)
  end
end
