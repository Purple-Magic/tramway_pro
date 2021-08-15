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
    convert episode
    montage episode, directory
    add_music episode, directory
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

    episode.download
    episode.save!
  end

  def cut_highlights(episode)
    episode.convert_file
    episode.cut_highlights
    episode.highlight_it
    episode.save!
  end

  def convert(episode)
    filename = episode.convert_file

    wait_for_file_rendered filename, :convert

    episode.convert
    episode.save!
  end

  def montage(episode, directory)
    output = "#{directory}/montage.mp3"

    episode.montage(filename, output)

    wait_for_file_rendered output, :montage

    save_premontage_file episode, output

    episode.prepare
    episode.save!
  end

  def add_music(episode, directory)
    output = "#{directory}/with_music.mp3"
    episode.add_music(episode.premontage_file.path, output)

    wait_for_file_rendered output, :with_music
    save_premontage_file episode, output

    episode.music_add
    episode.save!
  end

  def wait_for_file_rendered(output, file_type)
    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "#{file_type} file does not exist for #{index} seconds"
    end
  end

  def save_premontage_file(episode, output)
    File.open(output) do |f|
      episode.premontage_file = f
    end
    episode.save!
  end
end
