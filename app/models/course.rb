# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :topics, class_name: 'Courses::Topic', foreign_key: :course_id

  TEAMS = %i[slurm skillbox].freeze

  enumerize :team, in: TEAMS

  TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where team: team
    }
  end
end
