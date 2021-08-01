require 'net/ssh'

class PodcastsDownloadExternalFileJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    result = ''
    Net::SSH.start('167.71.46.15', 'root') do |ssh|
      result = 'ls /root/Documents/Mumble-*'
      external_filename = result.split(' ').last.split('/').last
      system("scp root@167.71.46.15:/root/Documents/#{external_filename} #{directory}/#{external_filename}")
    end
  end
end
