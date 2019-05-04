module MultiProjectConfigurationMiddleware 
  class User
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Tramway::User::UserForm.include MultiProjectCallbacks::User::UserForm

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
      end
    end
  end
end
