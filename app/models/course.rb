# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :topics, -> { order :position }, class_name: 'Courses::Topic', foreign_key: :course_id, dependent: :destroy
  has_many :lessons, class_name: 'Courses::Lesson', through: :topics
  has_many :videos, class_name: 'Courses::Video', through: :lessons
  has_many :tasks, class_name: 'Courses::Task', through: :lessons
  has_many :screencasts, class_name: 'Courses::Screencast', through: :videos

  enumerize :team, in: Courses::Teams::List

  Courses::Teams::List.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where team: team
    }
  end

  aasm do
    state :hack
  end

  include TimeConcern

  def video_duration_for(duration:)
    all_minutes = videos.sum do |video|
      video.minutes_of duration
    end
    time_view_by all_minutes
  end

  def tasks_duration
    min_minutes = tasks.sum do |task|
      task.min_time.present? ? task.min_time.gsub('m', '').to_i : 0
    end
    max_minutes = tasks.sum do |task|
      task.max_time.present? ? task.max_time.gsub('m', '').to_i : 0
    end
    "#{min_minutes / 60}h #{min_minutes % 60}m - #{max_minutes / 60}h #{max_minutes % 60}m"
  end

  def time_logs
    video_ids = videos.map(&:id)
    tasks_ids = tasks.map(&:id)
    TimeLog.where(associated_type: 'Courses::Video', associated_id: video_ids).or(
      TimeLog.where(associated_type: 'Courses::Task', associated_id: tasks_ids)
    )
  end

  def comments
    video_ids = videos.map(&:id)
    tasks_ids = tasks.map(&:id)
    Courses::Comment.where(associated_type: 'Courses::Video', associated_id: video_ids).or(
      Courses::Comment.where(associated_type: 'Courses::Task', associated_id: tasks_ids)
    )
  end
end
