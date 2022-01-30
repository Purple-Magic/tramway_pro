# frozen_string_literal: true

FactoryBot.define do
  factory :estimation_project, class: 'Estimation::Project' do
    title
    customer { create :estimation_customer }
  end
end
