class RedMagic::Api::V1::Podcast::HighlightsController < RedMagic::Api::V1::ApplicationController
  def create
    episode = Podcast::Episode.find params[:id]
    episode.cut_highlights

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(episode.id, model: Podcast::Episode)
  end
end
