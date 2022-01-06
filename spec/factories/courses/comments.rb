FactoryBot.define do
  factory :courses_comment, class: 'Courses::Comment' do
    begin_time { "00:00" }
    end_time { "00:01" }
    phrase { generate :string }
    text { generate :string }
    associated do
      associated_type = Courses::Comment.associated_type.values.sample
      create associated_type.underscore.gsub('/', '_')
    end
  end
end
