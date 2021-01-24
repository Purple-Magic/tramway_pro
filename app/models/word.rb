# frozen_string_literal: true

class Word < Tramway::Core::ApplicationRecord
  search_by :main, :synonims

  state_machine :review_state, initial: :approved do
    state :approved
    state :unviewed

    event :approve do
      transition unviewed: :approved
    end

    event :revoke do
      transition approved: :unviewed
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
  end
end
