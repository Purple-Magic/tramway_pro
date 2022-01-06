FactoryBot.define do
  factory :courses_task, class: 'Courses::Task' do
    text { generate :string }
    position { generate :integer }
    min_time { generate :duration }
    max_time { generate :duration }
    lesson { create :courses_lesson }
  end
end
