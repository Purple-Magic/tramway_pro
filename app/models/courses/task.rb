# frozen_string_literal: true

class Courses::Task < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'
  has_many :comments, -> { order(comment_state: :desc) }, class_name: 'Courses::Comment', as: :associated

  validates :position, presence: true

  ::Course::TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      joins(lesson: { topic: :course }).where 'courses.team' => team
    }
  end

  aasm :preparedness_state do
    state :writing, initial: true
    state :written
    state :uploaded
    state :verified

    event :finish_writing do
      transitions from: :writing, to: :written
    end

    event :upload do
      transitions from: :written, to: :uploaded
    end

    event :verify do
      transitions from: :uploaded, to: :verified
    end
  end

  def progress_status
    return preparedness_state if preparedness_state.in? [ 'writing' ]

    done_comments = comments.active.where(comment_state: :done).count
    conditions = {
      done: lambda do |all, done|
        (all.positive? || all == 0) && all == done
      end,
      in_progress: lambda do |_all, _done|
        preparedness_state == 'writing'
      end
    }

    conditions.each do |condition|
      return condition[0] if condition[1].call(comments.active.count, done_comments)
    end

    preparedness_state == 'verified' ? :done : preparedness_state.to_sym
  end
end
