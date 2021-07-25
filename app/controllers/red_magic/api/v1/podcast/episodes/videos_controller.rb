# frozen_string_literal: true

class RedMagic::Api::V1::Podcast::Episodes::VideosController < RedMagic::Api::V1::Podcast::Episodes::ApplicationController
  def create
    ::PodcastsVideosJob.perform_later params[:id]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: Podcast::Episode)
  end

  def show
    episode = Podcast::Episode.find params[:id]

    send_file "#{episode.parts_directory_name}/video.mp4"
  end
end
