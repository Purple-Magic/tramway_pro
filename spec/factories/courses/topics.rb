FactoryBot.define do
  factory :courses_topic, class: 'Courses::Topic' do
    title { "Topic #{generate(:title)}" }
    position { generate :integer }
    course
  end
end
