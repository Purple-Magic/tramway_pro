# frozen_string_literal: true

class RedMagic::Api::V1::Podcast::EpisodesController < RedMagic::Api::V1::Podcast::Episodes::ApplicationController
  def update
    ::PodcastsHighlightsJob.perform_later params[:id]
    ::PodcastsMontageJob.perform_later params[:id]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: Podcast::Episode)
  end
end
