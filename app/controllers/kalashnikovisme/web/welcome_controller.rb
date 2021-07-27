# frozen_string_literal: true

class Kalashnikovisme::Web::WelcomeController < Tramway::Core::ApplicationController
  before_action :application

  layout 'tramway/landing/application'

  def index; end
end
