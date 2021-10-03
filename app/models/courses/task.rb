# frozen_string_literal: true

class Courses::Task < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'
  has_many :comments, -> { order(comment_state: :desc) }, class_name: 'Courses::Comment', as: :associated

  aasm :preparedness_state do
    state :writing, initial: true
    state :written
    state :uploaded

    event :finish_writing do
      transitions from: :writing, to: :written
    end

    event :upload do
      transitions from: :written, to: :uploaded
    end
  end

  def progress_status
    done_comments = comments.active.where(comment_state: :done).count
    conditions = {
      done: lambda do |all, done|
        all.positive? && all == done
      end,
      in_progress: lambda do |all, done|
        all != done
      end
    }

    conditions.each do |condition|
      return condition[0] if condition[1].call(comments.active.count, done_comments)
    end

    preparedness_state.to_sym
  end
end
