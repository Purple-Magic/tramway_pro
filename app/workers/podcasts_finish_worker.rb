# frozen_string_literal: true

class PodcastsFinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub('//', '/')

    concat_parts directory, episode
    Rails.logger.info 'Concatination completed'

    render_trailer directory, episode
    Rails.logger.info 'Render trailer video completed'

    render_full_video directory, episode
    Rails.logger.info 'Render fulll video completed'
  end

  private

  def concat_parts(directory, episode)
    output = "#{directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)

    wait_for_file_rendered output, :trailer

    episode.update_file! output, :ready_file

    episode.make_audio_ready!
  end

  def render_trailer(directory, episode)
    output = "#{directory}/trailer.mp4"
    episode.render_video_trailer(output)

    wait_for_file_rendered output, :video_trailer

    episode.update_file! output, :trailer_video

    episode.make_video_trailer_ready!
  end

  def render_full_video(directory, episode)
    output = "#{directory}/full_video.mp4"
    episode.render_full_video(output)

    wait_for_file_rendered output, :full_video

    episode.update_file! output, :full_video

    episode.finish!
  end
end
