# frozen_string_literal: true

class ApplicationRecord < Tramway::Core::ApplicationRecord
  self.abstract_class = true

  acts_as_paranoid
end
