# frozen_string_literal: true

module ProjectScopes
  extend ActiveSupport::Concern

  included do
    default_scope do
      where project_id: Project.where(url: ENV['PROJECT_URL'])
    end

    scope :rsm_scope, -> { all }
    scope :podcast_scope, -> { all }
  end
end
