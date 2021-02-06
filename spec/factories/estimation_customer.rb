FactoryBot.define do
  factory :estimation_customer, class: 'Estimation::Customer' do
    title
    logo { generate :image_as_file }
    url
  end
end
