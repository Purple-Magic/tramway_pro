# frozen_string_literal: true

require 'tramway/collection'

class Collections::RifYoung2019Waves < ::Tramway::Collection
  class << self
    def list
      ['11:00 - 12.30',
       '13:00 - 14.30',
       '15:00 - 16.30']
    end
  end
end
