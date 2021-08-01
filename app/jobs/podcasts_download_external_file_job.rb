class PodcastsDownloadExternalFileJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    command = "ssh -t #{ENV['STREAM_SERVER_USER']}@#{ENV['STREAM_SERVER_IP']} 'ls /root/Documents/Mumble-*'"
    external_filename = `#{command}`.split(' ').last.split('/').last
    system("scp #{ENV['STREAM_SERVER_USER']}@#{ENV['STREAM_SERVER_IP']}:/root/Documents/#{external_filename} #{directory}/#{external_filename}")
  end
end
