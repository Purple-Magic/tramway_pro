# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    title { "Course #{generate(:title)}" }
    team { Courses::Teams::List.sample }
  end
end
