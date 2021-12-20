# frozen_string_literal: true

class RedMagic::Api::V1::Podcast::EpisodesController < RedMagic::Api::V1::Podcast::ApplicationController
  def update
    episode = Podcast::Episode.find params[:id]
    episode.send params[:process]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: Podcast::Episode)
  end

  def video_is_ready
    episode = Podcast::Episode.find params[:id]
    episode.download_video_from_remote_host!

    head :ok
  end
end
