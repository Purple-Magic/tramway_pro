# frozen_string_literal: true

class Courses::Task < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'
  has_many :comments, lambda {
                        order(comment_state: :desc)
                      }, class_name: 'Courses::Comment', as: :associated, dependent: :destroy

  validates :position, presence: true

  Courses::Teams::List.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      joins(lesson: { topic: :course }).where 'courses.team' => team
    }
  end

  aasm :preparedness_state, column: :preparedness_state do
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

  aasm do
    state :hack
  end

  def progress_status
    return preparedness_state if preparedness_state.in? ['writing']

    done_comments = comments.where(comment_state: :done).count
    conditions = {
      done: lambda do |all, done|
        (all.positive? || all.zero?) && all == done
      end,
      in_progress: lambda do |_all, _done|
        preparedness_state == 'writing'
      end
    }

    conditions.each do |condition|
      return condition[0] if condition[1].call(comments.count, done_comments)
    end

    preparedness_state == 'verified' ? :done : preparedness_state.to_sym
  end
end
