# frozen_string_literal: true

class Kalashnikovisme::Web::WelcomeController < Tramway::Core::ApplicationController
  before_action :application

  def index
    @podcast = Podcast.unscoped.find(2)
    @links = Blogs::Link.all
    @episodes = Podcast::Episode.unscoped.where(podcast_id: @podcast.id).where.not(public_title: nil).order(created_at: :desc).where(deleted_at: nil)
  end
end
