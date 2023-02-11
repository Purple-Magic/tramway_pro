# frozen_string_literal: true

module Middleware
  module MultiProjectConfigurationMiddleware
    class Landing
      def initialize(app)
        @app = app
      end

      def call(env)
        ::Admin::Tramway::Landing::BlockForm.include MultiProjectCallbacks::Landing::BlockForm
        ::Admin::Tramway::Landing::ToolForm.include MultiProjectCallbacks::Landing::ToolForm

        PhotoUploader.include Tramway::Landing::PhotoVersions

        @app.call(env)
      end
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

    module ToolForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end
