# frozen_string_literal: true

class PodcastsTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub('//', '/')
    output = "#{directory}/trailer.mp3"
    episode.build_trailer(output)

    wait_for_file_rendered output, :trailer

    episode.update_file! output, :trailer

    episode.trailer_finish!
  end
end
