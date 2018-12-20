module MultiProjectConfigurationMiddleware 
  class Partner
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Partner::OrganizationForm.include MultiProjectCallbacks::Partner::OrganizationForm

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Partner
    module OrganizationForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end
