FactoryBot.define do
  factory :courses_comment, class: 'Courses::Comment' do
    begin_time { "00:00" }
    end_time { "00:01" }
    phrase { generate :string }
    text { generate :string }
  end
end
