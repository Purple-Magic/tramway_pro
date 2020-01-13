module ProjectScopes
  extend ActiveSupport::Concern

  included do
    default_scope do
      where project_id: Project.where(url: ENV['PROJECT_URL'])
    end
  end
end
