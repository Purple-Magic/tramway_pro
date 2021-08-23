# frozen_string_literal: true

class PodcastsFinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    finish episode
  end

  private

  def finish(episode)
    send_notification_to_user :kalashnikovisme, 'Finishing podcast files'
    concat_parts episode
    send_notification_to_user :kalashnikovisme, 'File to upload is ready'
    render_trailer episode
    send_notification_to_user :kalashnikovisme, 'Video trailer is ready'
    render_full_video episode
    send_notification_to_user :kalashnikovisme, 'Full Video is ready'
  end

  def concat_parts(episode)
    output = "#{@directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)
    Rails.logger.info 'Concatination completed'
  end

  def render_trailer(episode)
    output = "#{@directory}/trailer.mp4"
    episode.render_video_trailer(output)

    Rails.logger.info 'Render trailer video completed'
  end

  def render_full_video(episode)
    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)

    Rails.logger.info 'Render fulll video completed'
  end
end
