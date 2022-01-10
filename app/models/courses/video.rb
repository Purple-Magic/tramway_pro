# frozen_string_literal: true

class Courses::Video < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'

  has_many :comments, lambda {
                        order(comment_state: :desc).order(:begin_time)
                      }, class_name: 'Courses::Comment', as: :associated
  has_many :time_logs, class_name: 'TimeLog', as: :associated

  validates :position, presence: true

  ::Course::TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      joins(lesson: { topic: :course }).where 'courses.team' => team
    }
  end

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
    done_comments = comments.where(comment_state: :done).count
    conditions = {
      done: lambda do |all, done|
        all.positive? && all == done
      end,
      in_progress: lambda do |all, done|
        all != done
      end
    }

    conditions.each do |condition|
      return condition[0] if condition[1].call(comments.count, done_comments)
    end

    video_state.to_sym
  end

  def minutes_of(duration_type)
    dur = public_send duration_type
    dur.present? ? dur.gsub('m', '').to_i : 0
  end
end
