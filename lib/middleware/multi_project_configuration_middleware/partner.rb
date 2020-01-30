# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class Partner
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::Partner::OrganizationForm.include MultiProjectCallbacks::Partner::OrganizationForm
      ::Tramway::Partner::PartnershipForm.include MultiProjectCallbacks::Partner::PartnershipForm
      ::Tramway::Partner::Organization.include MultiProjectCallbacks::Partner::OrganizationModel
      ::Tramway::Partner::Partnership.include MultiProjectCallbacks::Partner::PartnershipModel

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module Partner
    module OrganizationModel
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL']).first.id
        end
      end
    end

    module PartnershipModel
      extend ActiveSupport::Concern

      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL']).first.id
        end
      end
    end

    module OrganizationForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end

    module PartnershipForm
      extend ActiveSupport::Concern

      included do
        properties :project_id
      end
    end
  end
end
