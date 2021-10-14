# frozen_string_literal: true

class Content::Story < ApplicationRecord
  uploader :original_file, :file
  uploader :story, :file

  aasm :converting_state do
    state :ready, initial: true
    state :converting
    state :done

    event :convert do
      transitions to: :converting

      after do
        save!
        ContentStoriesWorker.perform_async id
      end
    end

    event :make_done do
      transitions to: :done
    end
  end
end
