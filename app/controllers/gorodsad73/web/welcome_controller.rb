# frozen_string_literal: true

class Gorodsad73::Web::WelcomeController < ApplicationController
  layout 'tramway/landing/application'

  def index
    @application = Constraints::DomainConstraint.new(request.domain).application_object
    project = Project.find_by(url: ENV['PROJECT_URL'])
    main_page = Tramway::Page::Page.where(project_id: project, page_type: :main).active.first
    @blocks = Tramway::Landing::BlockDecorator.decorate Tramway::Landing::Block.on_main_page
    pages_links = Tramway::Page::Page.where(project_id: project.id).where.not(page_type: :main).active.map do |page|
      Tramway::Landing::Navbar::LinkDecorator.decorate(
        {
          title: page.title,
          link: Tramway::Page::Engine.routes.url_helpers.page_path(page.slug)
        }
      )
    end
    pages_blocks = Tramway::Landing::Block.active.with_navbar_link.where(project_id: project.id, page_id: main_page.id)
    @links = pages_links + Tramway::Landing::BlockLinkDecorator.decorate(
      pages_blocks.order(position: :asc)
    )
  end
end
