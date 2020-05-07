# frozen_string_literal: true

class Gorodsad73::Web::WelcomeController < ApplicationController
  layout 'tramway/landing/application'

  def index
    @application = Constraints::DomainConstraint.new(request.domain).application_object
    @blocks = Tramway::Landing::BlockDecorator.decorate Tramway::Landing::Block.on_main_page
  end
end
