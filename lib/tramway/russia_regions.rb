# frozen_string_literal: true

require 'russia_regions'

class Tramway::RussiaRegions < ::Tramway::Collection
  class << self
    def list
      RussiaRegions.name_list
    end
  end
end
