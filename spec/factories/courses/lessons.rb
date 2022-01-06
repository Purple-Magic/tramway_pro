FactoryBot.define do
  factory :courses_lesson, class: 'Courses::Lesson' do
    title
    position { generate :integer }
    topic { create :courses_topic }
  end
end
