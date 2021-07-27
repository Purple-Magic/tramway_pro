# frozen_string_literal: true

class Courses::Topic < ApplicationRecord
  belongs_to :course, class_name: 'Course'

  has_many :lessons, class_name: 'Courses::Lesson'
end
