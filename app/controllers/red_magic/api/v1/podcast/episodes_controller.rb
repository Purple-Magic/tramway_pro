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
    episode = Podcast::Episode.find params[:id]
    params[:video_type] = :trailer_video
    episode.download_video_from_remote_host! params[:video_type]

    return unless params[:video_type].in? [ 'trailer_video', 'full_video' ]

    Rails.logger.info 'Render full video completed'
    send_notification_to_chat episode.podcast.chat_id, notification(:video, :finished, file_url: episode.public_send(params[:video_type]).url)
    ::Shortener::ShortenedUrl.generate(episode.public_send(params[:video_type]).url, owner: self)

    head :ok
  end
end
