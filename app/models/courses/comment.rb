class Courses::Comment < ApplicationRecord
  belongs_to :video, class_name: 'Courses::Video'

  aasm :comment_state do
    state :unviewed, initial: true
    state :done

    event :do_ti do
      transitions from: :unviewed, to: :done
    end
  end
end
