# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :topics, class_name: 'Courses::Topic', foreign_key: :course_id
end
