module Audited::AuditConcern
  extend ActiveSupport::Concern

  included do
    scope :active, -> { all }
    scope :admin_scope, -> (_current_user) { all }
  end
end
