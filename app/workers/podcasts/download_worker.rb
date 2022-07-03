# frozen_string_literal: true

require 'net/ssh'
require 'bot_telegram/leopold/chat_decorator'

class Podcasts::DownloadWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id
    download episode, episode.podcast.chat_id
    convert episode
  rescue StandardError => error
    log_error error
    send_notification_to_chat episode.podcast.chat_id, notification(:montage, :something_went_wrong)
  end

  private

  def convert(episode)
    episode.convert_file.tap do
      Rails.logger.info 'Converting completed!'
    end
  end

  def download(episode, chat_id)
    return if episode.file.present?

    directory = episode.prepare_directory.gsub('//', '/')
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
    send_notification_to_chat chat_id, notification(:footage, :downloaded)
  end

  def external_filename
    return @external_filename if @external_filename.present?

    Net::SSH.start('167.71.46.15', 'root') do |ssh|
      result = ssh.exec! 'ls /root/Documents/Mumble-*'
      return result.split.last.split('/').last
    end
  end
end
