# frozen_string_literal: true

class Podcasts::TrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub('//', '/')
    output = "#{directory}/trailer.mp3"
    episode.build_trailer(output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "Trailer file does not exist for #{index} seconds"
    end

    File.open(output) do |f|
      episode.trailer = f
    end

    episode.trailer_finish
    episode.save!
  end
end
