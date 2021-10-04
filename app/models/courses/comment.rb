# frozen_string_literal: true

class Courses::Comment < ApplicationRecord
  belongs_to :associated, polymorphic: true

  uploader :file, :file

  enumerize :associated_type, in: ['Courses::Video', 'Courses::Task']

  aasm :comment_state do
    state :unviewed, initial: true
    state :done

    event :do_it do
      transitions from: :unviewed, to: :done
    end
  end
end
