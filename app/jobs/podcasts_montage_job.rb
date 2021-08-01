# frozen_string_literal: true

class PodcastsMontageJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    external_filename = system("ssh -t #{ENV['STREAM_SERVER_USER']}@#{ENV['STREAM_SERVER_IP']} 'ls /root/Documents/Mumble-*'").last
    system("scp #{ENV['STREAM_SERVER_USER']}@#{ENV['STREAM_SERVER_IP']}:/root/Documents/#{external_filename} #{directory}/#{external_filename}")
    
    File.open("#{directory}/#{external_filename}") do |f|
      episode.file = f
    end
    episode.save!
    
    episode.montage

    filename = episode.convert_file

    # TODO: use lib/ffmpeg/builder.rb
    output = "#{directory}/montage.mp3"
    log = system "ffmpeg -y -i #{filename} -c:a libx264 -af silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-30dB,acompressor=threshold=-12dB:ratio=2:attack=200:release=1000,volume=-0.5dB #{output}"
    Rails.logger.info log

    File.open(output) do |f|
      episode.premontage_file = f
    end
    episode.save!

    episode.cut_highlights
    episode.highlight_it
  rescue StandardError => e
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
