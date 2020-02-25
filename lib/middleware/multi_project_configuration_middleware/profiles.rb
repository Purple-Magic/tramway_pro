# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Profiles
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::Profiles::SocialNetworkForm.include MultiProjectCallbacks::Profiles::SocialNetworkForm

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Profiles
    module SocialNetworkForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end
