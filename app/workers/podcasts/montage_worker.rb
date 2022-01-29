# frozen_string_literal: true

require 'bot_telegram/leopold/chat_decorator'

class Podcasts::MontageWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id
    montage episode
  rescue StandardError => error
    log_error error
    send_notification_to_chat episode.podcast.chat_id, notification(:montage, :something_went_wrong)
  end

  private

  def montage(episode)
    send_notification_to_chat episode.podcast.chat_id, notification(:montage, :started)
    cut_highlights episode
    remove_cut_pieces episode
    run_filters episode
    add_music episode if episode.podcast.podcast_type.sample?
  end

  # :reek:FeatureEnvy { enabled: false }
  def cut_highlights(episode)
    episode.cut_highlights
    episode.highlight_it!
    Rails.logger.info 'Cut highlights completed!'
    send_notification_to_chat episode.podcast.chat_id, notification(:highlights, :cut, episode_id: episode.id)
  end
  # :reek:FeatureEnvy { enabled: true }

  def remove_cut_pieces(episode)
    if episode.parts.any?
      Podcasts::Episodes::Montage::RemoveCutPiecesService.new(episode).call
    end
  end

  def run_filters(episode)
    episode.montage(episode.premontage_file.path)
    Rails.logger.info 'Montage completed!'
    send_notification_to_chat episode.podcast.chat_id, notification(:filter, :finished)
  end

  # :reek:FeatureEnvy { enabled: false }
  def add_music(episode)
    directory = episode.prepare_directory.gsub('//', '/')
    output = "#{directory}/with_music.mp3"
    episode.add_music(output)

    Rails.logger.info 'Adding of music completed!'
    send_notification_to_chat episode.podcast.chat_id, notification(:music, :finished, episode_id: episode.id)
  end
  # :reek:FeatureEnvy { enabled: true }
end
