# frozen_string_literal: true

class ItWay::PodcastsController < Tramway::Core::ApplicationController
  layout 'tramway/landing/application'
  before_action :application

  def show
    @episodes = ::EpisodeBlockDecorator.decorate Episode.order(published_at: :desc)
  end
end
