# frozen_string_literal: true

require 'net/ssh'

class PodcastsMontageWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id
    montage episode
  rescue StandardError => error
    log_error error
  end

  private

  def montage(episode)
    chat_id = BotTelegram::Leopold::Scenario::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, 'Техническое сообщение. Монтаж подкаста начался!'
    download episode
    send_notification_to_chat chat_id, 'Техническое сообщение. Аудиозапись подгружена. Она корректна'
    cut_highlights episode
    send_notification_to_chat chat_id,
      "Техническое сообщение. Порезал хайлайты. Их можно идти и прослушивать, чтобы собрать трейлер. http://red-magic.ru/admin/records/#{episode.id}?model=Podcast::Episode"
    filename = convert episode
    send_notification_to_chat chat_id, 'Техническое сообщение. Конвертирование прошло успешно'
    run_filters episode, filename
    send_notification_to_chat chat_id, 'Техничеcкое сообщение. Фильтрация звуковой дорожки прошла успешно'
    add_music episode
    send_notification_to_chat chat_id,
      "Техническое сообщение. Музыка наложена. Если вы уже подготовили трейлер. Можно запускать завершение. http://red-magic.ru/admin/records/#{episode.id}?model=Podcast::Episode"
  end

  def download(episode)
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
  end

  def external_filename
    return @external_filename if @external_filename.present?

    Net::SSH.start('167.71.46.15', 'root') do |ssh|
      result = ssh.exec! 'ls /root/Documents/Mumble-*'
      return result.split.last.split('/').last
    end
  end

  def cut_highlights(episode)
    episode.cut_highlights
    episode.highlight_it!
    Rails.logger.info 'Cut highlights completed!'
  end

  def convert(episode)
    episode.convert_file.tap do
      Rails.logger.info 'Converting completed!'
    end
  end

  def run_filters(episode, filename)
    episode.montage(filename)
    Rails.logger.info 'Montage completed!'
  end

  def add_music(episode)
    directory = episode.prepare_directory.gsub('//', '/')
    output = "#{directory}/with_music.mp3"
    episode.add_music(output)

    Rails.logger.info 'Adding of music completed!'
  end
end
