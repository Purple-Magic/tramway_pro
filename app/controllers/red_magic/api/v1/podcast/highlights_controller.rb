class RedMagic::Api::V1::Podcast::HighlightsController < RedMagic::Api::V1::ApplicationController
  def create
    ::Podcasts::HighlightsWorker.perform_async params[:id]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: Podcast::Episode)
  end
end
