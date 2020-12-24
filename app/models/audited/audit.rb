class Audited::Audit < ::ActiveRecord::Base
  extend Tramway::Core::ApplicationRecord

  scope :active, -> { all }
end
