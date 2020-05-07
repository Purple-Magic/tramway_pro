# frozen_string_literal: true

class Gorodsad73::Web::WelcomeController < ApplicationController
  layout 'tramway/landing/application'

  def index
    @application = Constraints::DomainConstraint.new(request.domain).application_object
    @blocks = Tramway::Landing::BlockDecorator.decorate Tramway::Landing::Block.on_main_page
    project = Project.find_by(url: ENV['PROJECT_URL'])
    @links = Tramway::Landing::BlockLinkDecorator.decorate(
      Tramway::Landing::Block.active.with_navbar_link.where(project_id: project.id)
    )
  end
end
