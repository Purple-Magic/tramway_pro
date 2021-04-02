# frozen_string_literal: true

class RedMagic::Api::V1::Podcast::HighlightsController < RedMagic::Api::V1::ApplicationController
  def create
    ::PodcastsHighlightsJob.perform_later params[:id]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: Podcast::Episode)
  end
end
