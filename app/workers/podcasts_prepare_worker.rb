class PodcastsPrepareWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  version 1

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    external_filename = Dir["#{directory}/*.ogg"].last

    File.open(external_filename) do |f|
      episode.file = f
    end

    episode.save!
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end
end
