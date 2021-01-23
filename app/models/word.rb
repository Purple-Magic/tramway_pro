# frozen_string_literal: true

class Word < Tramway::Core::ApplicationRecord
  search_by :main, :synonims
end
