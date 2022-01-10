class Courses::Screencast < ApplicationRecord
  belongs_to :video, class_name: 'Courses::Video'
end
