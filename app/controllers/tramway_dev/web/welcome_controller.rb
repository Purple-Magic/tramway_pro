# frozen_string_literal: true

class TramwayDev::Web::WelcomeController < ApplicationController
  layout 'tramway/landing/application'

  before_action :application

  def index
    project = Project.find_by(url: ENV['PROJECT_URL'])
    main_page = Tramway::Page::Page.where(project_id: project, page_type: :main).first
    @blocks = Tramway::Landing::BlockDecorator.decorate Tramway::Landing::Block.on_main_page
    pages_links = Tramway::Page::Page.where(project_id: project.id).where.not(page_type: :main).map do |page|
      link = Tramway::Page::Engine.routes.url_helpers.page_path(page.slug)
      Tramway::Landing::Navbar::LinkDecorator.decorate({ title: page.title, link: link })
    end
    pages_blocks = Tramway::Landing::Block.with_navbar_link.where(project_id: project.id, page_id: main_page.id)
    @links = pages_links + Tramway::Landing::BlockLinkDecorator.decorate(
      pages_blocks.order(position: :asc)
    )
  end

  def application
    @application = Constraints::DomainConstraint.new(request.domain).application_class.camelize.constantize.first
  end
end
