# frozen_string_literal: true

class Courses::Lesson < ApplicationRecord
  belongs_to :topic, class_name: 'Courses::Topic'

  has_many :videos,  -> { order(:position) }, class_name: 'Courses::Video'
end
