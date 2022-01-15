# frozen_string_literal: true

class RedMagic::Api::V1::Podcast::EpisodesController < RedMagic::Api::V1::Podcast::ApplicationController
  include BotTelegram::Leopold::Notify
  include Podcasts

  def update
    episode = Podcast::Episode.find params[:id]
    episode.send params[:process]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: Podcast::Episode)
  end

  def video_is_ready
    return unless params[:video_type].in? %w[trailer_video full_video]

    episode = Podcast::Episode.find params[:id]
    episode.download_video_from_remote_host! params[:video_type]

    Rails.logger.info 'Render full video completed'
    ::Shortener::ShortenedUrl.generate(episode.public_send(params[:video_type]).url, owner: self)
    send_notification_to_chat(
      episode.podcast.chat_id,
      notification(params[:video_type], :finished, file_url: episode.public_send(params[:video_type]).url)
    )

    head :ok
  end
end
