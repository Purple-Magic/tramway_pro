module MultiProjectConfigurationMiddleware 
  class ITWay
    def initialize(app)
      @app = app
    end

    def call(env)
      WordForm.include MultiProjectCallbacks::ITWay::WordForm

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module ITWay
    module WordForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end
