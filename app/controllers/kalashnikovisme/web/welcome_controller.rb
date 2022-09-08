# frozen_string_literal: true

class Kalashnikovisme::Web::WelcomeController < Tramway::Core::ApplicationController
  before_action :application

  def index
    @podcast = Podcast.unscoped.find(2)
    @links = Blogs::Link.all
    @episodes = @podcast.episodes.unscoped.where.not(public_title: nil).order(created_at: :desc)
  end
end
