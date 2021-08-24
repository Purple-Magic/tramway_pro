# frozen_string_literal: true

class Courses::Video < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'

  has_many :comments, class_name: 'Courses::Comment'
  has_many :time_logs, class_name: 'TimeLog', as: :associated
end
