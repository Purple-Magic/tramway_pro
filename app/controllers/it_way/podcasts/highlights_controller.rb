# frozen_string_literal: true

class ItWay::Podcasts::HighlightsController < Tramway::ApplicationController
  layout 'tramway/admin/application'
  before_action :application

  def new
    @podcast_highlight
  end
end
