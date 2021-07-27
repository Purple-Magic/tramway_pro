class Courses::Video < ApplicationRecord
  belongs_to :lesson, class_name: 'Courses::Lesson'

  has_many :comments, class_name: 'Courses::Comment'
end
