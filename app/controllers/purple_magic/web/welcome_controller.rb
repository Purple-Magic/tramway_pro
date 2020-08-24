class PurpleMagic::Web::WelcomeController < ApplicationController
  before_action :application
  
  layout 'tramway/landing/application'

  def index
    @blocks = ::Tramway::Landing::BlockDecorator.decorate ::Tramway::Landing::Block.on_main_page
  end
  
  private
  
  def application
    @application = ::Tramway::Core.application_object
  end
end