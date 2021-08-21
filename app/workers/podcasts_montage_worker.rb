# frozen_string_literal: true

require 'net/ssh'

class PodcastsMontageWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id
    montage episode
  rescue StandardError => error
    log_error error
  end

  private

  def montage(episode)
    download episode
    cut_highlights episode
    filename = convert episode
    run_filters episode, filename
    add_music episode
  end

  def download(episode)
    directory = prepare_directory.gsub('//', '/')
    Net::SCP.download!(
      '167.71.46.15',
      'root',
      "/root/Documents/#{external_filename}",
      "#{directory}/#{external_filename}"
    )

    File.open("#{directory}/#{external_filename}") do |std_file|
      episode.file = std_file
    end

    episode.download!
  end

  def external_filename
    return @external_filename if @external_filename.present?

    Net::SSH.start('167.71.46.15', 'root') do |ssh|
      result = ssh.exec! 'ls /root/Documents/Mumble-*'
      return result.split.last.split('/').last
    end
  end

  def cut_highlights(episode)
    episode.convert_file
    episode.cut_highlights
    episode.highlight_it!
    Rails.logger.info 'Cut highlights completed!'
  end

  def convert(episode)
    episode.convert_file
    Rails.logger.info 'Converting completed!'
  end

  def run_filters(episode, filename)
    episode.montage(filename, output)
    Rails.logger.info 'Montage completed!'
  end

  def add_music(episode, directory)
    output = "#{directory}/with_music.mp3"
    episode.add_music(episode.premontage_file.path, output)

    Rails.logger.info 'Adding of music completed!'
  end
end
