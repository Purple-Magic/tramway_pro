# frozen_string_literal: true

class Tramway::Core::ApplicationController < ActionController::Base
  before_action :application

  class << self
    def before_render(method, **options)
      @before_render_methods ||= {}
      @before_render_methods[options[:only]] ||= []
      @before_render_methods[options[:only]] << method
    end

    def before_render_methods
      @before_render_methods || {}
    end
  end

  def render(*args)
    self.class.before_render_methods[action_name.to_sym]&.each do |method|
      send method
    end
    super
  end

  # FIXME: it's repeat of tramway-core/application_controller method

  def application
    @application = ::Tramway::Core.application_object
  end
end
