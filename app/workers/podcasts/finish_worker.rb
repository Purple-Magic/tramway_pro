# frozen_string_literal: true

class Podcasts::FinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    finish episode
  rescue StandardError => error
    log_error error
  end

  private

  def finish(episode)
    send_notification_to_chat episode.podcast.chat_id, notification(:finish, :started)
    concat_parts episode
    send_notification_to_chat episode.podcast.chat_id, notification(:audio, :finished, file_url: episode.ready_file.url)
    render_instagram_stories episode
  end

  def concat_parts(episode)
    output = "#{@directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)
    Rails.logger.info 'Concatination completed'
  end

  def render_instagram_stories(episode)
    episode.using_highlights.each(&:render_instagram_story)
  end
end
