# frozen_string_literal: true

require 'net/ssh'

class PodcastsMontageWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub('//', '/')
    download episode, directory

    cut_highlights episode
    Rails.logger.info 'Cut highlights completed!'

    filename = convert episode
    Rails.logger.info 'Converting completed!'

    montage episode, directory, filename
    Rails.logger.info 'Montage completed!'

    add_music episode, directory
    Rails.logger.info 'Adding of music completed!'
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end

  private

  def download(episode, directory)
    external_filename = ''
    Net::SSH.start('167.71.46.15', 'root') do |ssh|
      result = ssh.exec! 'ls /root/Documents/Mumble-*'
      external_filename = result.split.last.split('/').last
    end
    Net::SCP.download!('167.71.46.15', 'root', "/root/Documents/#{external_filename}",
      "#{directory}/#{external_filename}")

    File.open("#{directory}/#{external_filename}") do |f|
      episode.file = f
    end

    episode.download!
  end

  def cut_highlights(episode)
    episode.convert_file
    episode.cut_highlights
    episode.highlight_it!
  end

  def convert(episode)
    filename = episode.convert_file

    filename.tap do
      wait_for_file_rendered filename, :convert

      episode.convert!
    end
  end

  def montage(episode, directory, filename)
    output = "#{directory}/montage.mp3"

    episode.montage(filename, output)

    wait_for_file_rendered output, :montage

    episode.update_file! output, :premontage_file

    episode.prepare!
  end

  def add_music(episode, directory)
    output = "#{directory}/with_music.mp3"
    episode.add_music(episode.premontage_file.path, output)

    wait_for_file_rendered output, :with_music
    episode.update_file! output, :premontage_file

    episode.music_add!
  end
end
