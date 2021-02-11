# frozen_string_literal: true

class RedMagic::Web::WelcomeController < ApplicationController
  before_action :application

  layout 'tramway/landing/application'

  def index
    @blocks = ::Tramway::Landing::BlockDecorator.decorate ::Tramway::Landing::Block.on_main_page
    @tools = ::Tramway::Landing::Tool.active
  end

  private

  def application
    @application = Constraints::DomainConstraint.new(request.domain).application_object
  end
end
