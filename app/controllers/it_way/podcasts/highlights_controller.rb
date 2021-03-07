class ItWay::Podcasts::HighlightsController < Tramway::Core::ApplicationController
  layout 'tramway/admin/application'
  before_action :application

  def new
    @podcast_highlight
  end
end
