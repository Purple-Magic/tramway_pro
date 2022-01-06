FactoryBot.define do
  factory :courses_topic, class: 'Courses::Topic' do
    title
    position { generate :integer }
  end
end
