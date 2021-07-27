# frozen_string_literal: true

class Courses::Topic < ApplicationRecord
  belongs_to :course

  has_many :lessons, class_name: 'Courses::Lesson'
end
