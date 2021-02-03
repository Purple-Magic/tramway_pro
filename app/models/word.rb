# frozen_string_literal: true

class Word < Tramway::Core::ApplicationRecord
  search_by :main, :synonims

  aasm :review_state do
    state :approved, initial: true
    state :unviewed

    event :approve do
      transitions from: :unviewed, to: :approved
    end

    event :revoke do
      transitions from: :approved, to: :unviewed
    end
  end

  scope :approved, -> { where review_state: :approved }
  scope :unviewed, -> { where review_state: :unviewed }

  class << self
    def find_records_by(word, collection)
      collection.where(main: word.downcase) + (collection.select do |record|
        record.synonims&.include? word.downcase
      end)
    end

    def all_words_with_synonims
      all.map(&:main) + all.map(&:synonims).flatten
    end
  end
end
