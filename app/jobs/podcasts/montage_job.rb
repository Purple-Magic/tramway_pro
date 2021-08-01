# frozen_string_literal: true

class Podcasts::MontageJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    

    filename = episode.convert_file

    # TODO: use lib/ffmpeg/builder.rb
    Rails.logger.info log


  rescue StandardError => e
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
