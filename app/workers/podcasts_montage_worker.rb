require 'net/ssh'

class PodcastsMontageWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')

    # Download
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

    # Cut highlights
    episode.convert_file
    episode.cut_highlights
    episode.highlight_it
    episode.save!

    # Convert
    filename = episode.convert_file

    index = 0
    until File.exist?(filename)
      sleep 1
      index += 1
      Rails.logger.info "Convert file does not exist for #{index} seconds"
    end

    episode.convert
    episode.save!

    # Montage
    output = "#{directory}/montage.mp3"

    episode.montage(filename, output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "Montage file does not exist for #{index} seconds"
    end

    File.open(output) do |f|
      episode.premontage_file = f
    end

    episode.prepare
    episode.save!

    # Normalize
#    output = "#{directory}/normalize.mp3"
#    episode.normalize(episode.premontage_file.path, output)
#
#    index = 0
#    until File.exist?(output)
#      sleep 1
#      index += 1
#      Rails.logger.info "Normalized file does not exist for #{index} seconds"
#    end
#    File.open(output) do |f|
#      episode.premontage_file = f
#    end
#    episode.to_normalize
#    episode.save!

    # Add music
    output = "#{directory}/with_music.mp3"
    episode.add_music(episode.premontage_file.path, output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "With music file does not exist for #{index} seconds"
    end
    File.open(output) do |f|
      episode.premontage_file = f
    end

    episode.music_add
    episode.save!
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end
end
