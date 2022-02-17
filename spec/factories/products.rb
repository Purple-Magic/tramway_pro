FactoryBot.define do
  factory :product do
    title
    chat_id { generate :string }
  end
end
