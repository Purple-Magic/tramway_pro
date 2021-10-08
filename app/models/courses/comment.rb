# frozen_string_literal: true

class Courses::Comment < ApplicationRecord
  belongs_to :associated, polymorphic: true

  uploader :file, :file

  enumerize :associated_type, in: ['Courses::Video', 'Courses::Task']

  ::Course::TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where(id: select do |comment|
        comment.associated.lesson.topic.course.team == team.to_s
      end.map(&:id))
    }
  end

  aasm :comment_state do
    state :unviewed, initial: true
    state :done

    event :do_it do
      transitions from: :unviewed, to: :done
    end
  end
end
