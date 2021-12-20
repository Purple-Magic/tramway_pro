# frozen_string_literal: true

class Podcasts::RenderVideoWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id, podcast)
    episode = Podcast::Episode.find id

    @directory = episode.prepare_directory
    @directory = @directory.gsub('//', '/')
    render_video episode, podcast
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end

  private

  def render_video(episode, podcast)
    return if episode.full_video.present?

    chat_id = case podcast
              when :it_way_podcast
              when :do_re_missii
                BotTelegram::Leopold::ChatDecorator::DO_RE_MISSII
              end
    render_full_video episode
    send_notification_to_chat chat_id, notification(:video, :finished, file_url: episode.full_video.url)
  end

  def render_full_video(episode)
    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)

    Rails.logger.info 'Render full video completed'
  end
end
