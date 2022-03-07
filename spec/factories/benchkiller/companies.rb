# frozen_string_literal: true

FactoryBot.define do
  factory :benchkiller_company, class: 'Benchkiller::Company' do
    title { Faker::Company.name }
    data do
      {
        portfolio_url: generate(:url),
        company_url: generate(:url),
        email: generate(:email),
        place: generate(:string),
        phone: generate(:phone),
        regions_to_cooperate: (1..5).to_a.map do
          Faker::Address.country
        end
      }
    end

    after :create do |company|
      company.users.create! attributes_for(:benchkiller_user, password: '123')
    end
  end
end
