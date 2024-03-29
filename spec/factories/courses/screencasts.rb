# frozen_string_literal: true

FactoryBot.define do
  factory :courses_screencast, class: 'Courses::Screencast' do
    begin_time { '00:00' }
    end_time { '00:01' }
    video { create :courses_video }
    comment { generate :string }

    trait :without_associations do
      video { nil }
    end
  end
end
