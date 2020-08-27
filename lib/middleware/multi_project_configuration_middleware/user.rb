# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class User
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::User::UserForm.include MultiProjectCallbacks::User::UserForm
      ::Tramway::User::User.include MultiProjectCallbacks::User::UserCallbacks

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module User
    module UserForm
      extend ActiveSupport::Concern
      included do
        properties :project_id
        binding.pry

        project = Project.where(url: ENV['PROJECT_URL'])
        validates :email, uniqueness: true, if: 'project_id == project'
      end
    end

    module UserCallbacks
      extend ActiveSupport::Concern
      included do
        default_scope do
          where project_id: Project.where(url: ENV['PROJECT_URL'])
        end
      end
    end
  end
end
