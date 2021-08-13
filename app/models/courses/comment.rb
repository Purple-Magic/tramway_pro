# frozen_string_literal: true

class Courses::Comment < ApplicationRecord
  belongs_to :video, class_name: 'Courses::Video'

  uploader :file, :file

  aasm :comment_state do
    state :unviewed, initial: true
    state :done

    event :do_it do
      transitions from: :unviewed, to: :done
    end
  end
end
