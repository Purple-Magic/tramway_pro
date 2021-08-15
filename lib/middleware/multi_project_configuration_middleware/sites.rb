# frozen_string_literal: true

require_relative '../multi_project_callbacks/sites'

module Middleware
  module MultiProjectConfigurationMiddleware
    class Sites
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
