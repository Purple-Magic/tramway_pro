class PodcastsFinishJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    output = episode.converted_file + '.mp3'

    File.open(output) do |f|
      episode.premontage_file = f
    end

    episode.save!
    episode.cut_highlights
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end
end
