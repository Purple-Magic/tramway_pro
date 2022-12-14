# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class User
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Admin::Tramway::UserForm.include MultiProjectCallbacks::UserForm
      ::Tramway::User.include MultiProjectCallbacks::UserCallbacks

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module UserForm
    extend ActiveSupport::Concern
    # included do
    #   properties :project_id
    # end
  end

  module UserCallbacks
    extend ActiveSupport::Concern
    included do
      #   p_id = Project.find_by(url: ENV['PROJECT_URL']).id
      #   validates :email, uniqueness: true, if: -> { project_id == p_id }

      #   default_scope do
      #     where project_id: Project.where(url: ENV['PROJECT_URL'])
      #   end

      enumerize :role, in: %i[admin user partner rsm night podcast slurm skillbox benchkiller hexlet], default: :admin
    end
  end
end
