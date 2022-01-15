FactoryBot.define do
  factory :benchkiller_company, class: 'Benchkiller::Company' do
    title
    data do
      {
        portfolio_url: generate(:url),
        company_url: generate(:url),
        email: generate(:email),
        place: generate(:string),
        phone: generate(:phone),
        regions_to_cooperate: generate(:string)
      }
    end 
  end
end
