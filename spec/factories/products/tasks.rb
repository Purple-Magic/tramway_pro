FactoryBot.define do
  factory :products_task, class: 'Products::Task' do
    title
    card_id { generate :string }
    product
  end
end
