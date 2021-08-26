# frozen_string_literal: true

class Courses::Video < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'

  has_many :comments, class_name: 'Courses::Comment'
  has_many :time_logs, class_name: 'TimeLog', as: :associated

  def progress_status
    done_comments = comments.active.where(comment_state: :done)
    return :done if comments.active.any? && comments.count == done_comments.count
    return :in_progress if comments.active.count != done_comments.count
    return :not_started if comments.active.empty?
  end
end
