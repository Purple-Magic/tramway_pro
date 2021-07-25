# frozen_string_literal: true

class PodcastsVideosJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    episode = ::Podcast::Episode.find id

    command = "ffmpeg -y -loop 1 -i #{episode.cover.path} -i #{episode.ready_file.path} -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest #{episode.parts_directory_name}/video.mp4"
    system command
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end
end
