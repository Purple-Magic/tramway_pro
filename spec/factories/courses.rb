FactoryBot.define do
  factory :course_attributes, class: Course do
    title
    team { ::Course.team.values.sample }
  end
end
