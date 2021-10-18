# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :topics, class_name: 'Courses::Topic', foreign_key: :course_id
  has_many :lessons, class_name: 'Courses::Lesson', through: :topics
  has_many :videos, class_name: 'Courses::Video', through: :lessons

  TEAMS = %i[slurm skillbox].freeze

  enumerize :team, in: TEAMS

  TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where team: team
    }
  end

  def video_duration
    minutes = videos.active.sum do |video|
      video.duration.gsub('m', '')
    end
    "#{minutes}m"
  end
end
