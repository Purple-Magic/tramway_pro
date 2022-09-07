# frozen_string_literal: true

class Kalashnikovisme::Web::WelcomeController < Tramway::Core::ApplicationController
  before_action :application

  def index
    @links = Blogs::Link.all
  end
end
