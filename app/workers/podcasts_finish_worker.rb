# frozen_string_literal: true

class PodcastsFinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include Podcasts::Concerns

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub('//', '/')

    concatinate_parts episode, directory
    render_video_trailer episode, directory
    render_full_video episode, directory
  end

  private

  def concatinate_parts(episode, directory)
    output = "#{directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)

    wait_for_file_rendered output, :ready_file

    episode.update_file! output, :ready_file
    episode.make_audio_ready
    episode.save!
  end

  def render_video_trailer(episode, directory)
    output = "#{directory}/trailer.mp4"
    episode.render_video_trailer(output)

    wait_for_file_rendered output, :video_trailer

    episode.update_file! output, :trailer_video

    episode.make_video_trailer_ready
    episode.save!
  end

  def render_full_video(episode, directory)
    output = "#{directory}/full_video.mp4"
    episode.render_full_video(output)

    wait_for_file_rendered output, :full_video

    episode.update_file! output, :full_video

    episode.finish
    episode.save!
  end
end
