# frozen_string_literal: true

FactoryBot.define do
  factory :courses_video, class: 'Courses::Video' do
    text { generate :string }
    position { generate :integer }
    release_date { generate :date }
    duration
    lesson { create :courses_lesson }
  end
end
