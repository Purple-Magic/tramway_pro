# frozen_string_literal: true

FactoryBot.define do
  factory :find_meds_base, class: 'FindMeds::Base' do
    name { :copy }
    key { SecureRandom.hex(8) }
  end
end
