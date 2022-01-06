# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    title { "Course #{generate(:title)}" }
    team { ::Course.team.values.sample }
  end
end
