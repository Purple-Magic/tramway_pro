# frozen_string_literal: true

class Courses::Video < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'

  has_many :comments, lambda {
                        order(comment_state: :desc).order(:begin_time)
                      }, class_name: 'Courses::Comment', as: :associated
  has_many :time_logs, class_name: 'TimeLog', as: :associated

  aasm :video_state do
    state :ready, initial: true
    state :written
    state :filmed
    state :finished

    event :write do
      transitions from: :ready, to: :written
    end

    event :shoot do
      transitions from: :written, to: :filmed
    end

    event :finish do
      transitions from: :filmed, to: :finished
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

    video_state.to_sym
  end
end
