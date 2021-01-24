# frozen_string_literal: true

class Word < Tramway::Core::ApplicationRecord
  search_by :main, :synonims

  class << self
    def find_records_by(word, collection)
      collection.where(main: word.downcase) + (collection.select do |record|
        record.synonims&.include? word.downcase
      end)
    end
  end
end
