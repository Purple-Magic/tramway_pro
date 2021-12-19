# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :topics, -> { order :position }, class_name: 'Courses::Topic', foreign_key: :course_id
  has_many :lessons, -> { active }, class_name: 'Courses::Lesson', through: :topics
  has_many :videos, -> { active }, class_name: 'Courses::Video', through: :lessons
  has_many :tasks, -> { active }, class_name: 'Courses::Task', through: :lessons

  TEAMS = %i[slurm skillbox].freeze

  enumerize :team, in: TEAMS

  TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where team: team
    }
  end

  def video_duration
    minutes = videos.sum do |video|
      video.duration.present? ? video.duration.gsub('m', '').to_i : 0
    end
    "#{minutes / 60}h #{minutes % 60}m"
  end

  def tasks_duration
    min_minutes = tasks.sum do |task|
      task.min_time.gsub('m', '').to_i
    end
    max_minutes = tasks.sum do |task|
      task.max_time.gsub('m', '').to_i
    end
    "#{min_minutes / 60}h #{min_minutes % 60}m - #{max_minutes / 60}h #{max_minutes % 60}m"
  end
end
