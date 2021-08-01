class PodcastsPrepareJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    external_filename = Dir["#{directory}/*.ogg"].last

    File.open(external_filename) do |f|
      episode.file = f
    end

    episode.save!
  end
end
