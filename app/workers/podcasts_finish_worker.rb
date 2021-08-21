# frozen_string_literal: true

class PodcastsFinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = directory.gsub('//', '/')
    render episode
  end

  private

  def finish(episode)
    concat_parts episode
    render_trailer episode
    render_full_video episode
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
