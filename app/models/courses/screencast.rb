# frozen_string_literal: true

class Courses::Screencast < ApplicationRecord
  belongs_to :video, class_name: 'Courses::Video'
end
