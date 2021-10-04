# frozen_string_literal: true

class RedMagic::Api::V1::Content::StoriesController < RedMagic::Api::V1::Content::ApplicationController
  def update
    story = ::Content::Story.find params[:id]
    story.public_send params[:process]

    redirect_to ::Tramway::Admin::Engine.routes.url_helpers.record_path(params[:id], model: ::Content::Story)
  end
end
