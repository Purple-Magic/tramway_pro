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
    binding.pry
    episode.save!


#    directory = episode.prepare_directory
#    directory = directory.gsub("//", '/')
#    external_filename = Dir["#{directory}/*.ogg"].last
#
#
#
#    filename = episode.convert_file
#
#    directory = episode.prepare_directory
#    directory = directory.gsub("//", '/')
#    output = "#{directory}/montage.mp3"
#
#    system "ffmpeg -y -i #{filename} -vcodec libx264 -af silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-30dB,acompressor=threshold=-12dB:ratio=2:attack=200:release=1000,volume=-0.5dB -b:a 320k #{output}"
#
#    directory = episode.prepare_directory
#    directory = directory.gsub("//", '/')
#    output = episode.converted_file + '.mp3'
#
#    File.open(output) do |f|
#      episode.premontage_file = f
#    end
#
#    episode.save!
#    episode.cut_highlights
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end
end
