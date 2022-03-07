# frozen_string_literal: true

FactoryBot.define do
  factory :benchkiller_delivery, class: 'Benchkiller::Delivery' do
    user { create :benchkiller_user, password: '123456' }
    text { Faker::Lorem.sentence }
  end
end
