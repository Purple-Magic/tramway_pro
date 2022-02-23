# frozen_string_literal: true

FactoryBot.define do
  factory :products_task, class: 'Products::Task' do
    title
    card_id { generate :string }
    product_id { Product.last&.id || create(:product).id }
  end
end
