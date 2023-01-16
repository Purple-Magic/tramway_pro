# frozen_string_literal: true

class Courses::Screencast < ApplicationRecord
  belongs_to :video, class_name: 'Courses::Video'

  uploader :file, :file

  Courses::Teams::List.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      joins(video: { lesson: { topic: :course } }).where 'courses.team' => team
    }
  end

  aasm do
    state :hack
  end
end
