# frozen_string_literal: true

FactoryBot.define do
  factory :find_meds_feedback, class: 'FindMeds::Feedback' do
    text { generate :string }
  end
end
