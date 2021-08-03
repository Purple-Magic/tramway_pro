require 'net/ssh'

class PodcastsDownloadExternalFileWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    external_filename = ''
    Net::SSH.start('167.71.46.15', 'root') do |ssh|
      result = ssh.exec! 'ls /root/Documents/Mumble-*'
      external_filename = result.split(' ').last.split('/').last
    end
    Net::SCP.download!('167.71.46.15', 'root', "/root/Documents/#{external_filename}",  "#{directory}/#{external_filename}")

    File.open("#{directory}/#{external_filename}") do |f|
      episode.file = f
    end

    episode.download
    episode.save!

    filename = episode.convert_file
    episode.convert
    episode.save!
    output = "#{directory}/montage.mp3"

    if episode.montage(filename, output)
      File.open(output) do |f|
        episode.premontage_file = f
      end
    end

    episode.prepare
    episode.save!

    episode.save!
    episode.cut_highlights

    episode.highlight_it
    episode.save!
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end
end
