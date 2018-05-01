module ProjectScopes
  extend ActiveSupport::Concern

  included do
    default_scope { where project_id: Project.where(url: ENV['PROJECT_URL']) }
  end
end

Tramway::Landing::Block.send :include, ProjectScopes
