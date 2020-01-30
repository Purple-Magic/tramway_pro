# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Landing
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Landing::BlockForm.include MultiProjectCallbacks::Landing::BlockForm

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Landing
    module BlockForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end
