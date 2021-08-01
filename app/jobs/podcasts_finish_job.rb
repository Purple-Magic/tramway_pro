class PodcastsFinishJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    output = "#{directory}/montage.mp3"

    File.open(output) do |f|
      episode.premontage_file = f
    end

    episode.save!
    episode.cut_highlights
  end
end
