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
    episode.download_video_from_remote_host!

    Rails.logger.info 'Render full video completed'
    send_notification_to_chat episode.podcast.chat_id, notification(:video, :finished, file_url: episode.full_video.url)

    head :ok
  end
end
