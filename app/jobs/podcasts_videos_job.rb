# frozen_string_literal: true

class PodcastsVideosJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    episode = ::Podcast::Episode.find params[:id]

    system "ffmpeg -loop 1 -i #{episode.cover} -i #{episode.ready_file} -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest #{episode.parts_directory_name}/video.mp4"
  rescue
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
