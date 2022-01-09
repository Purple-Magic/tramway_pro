FactoryBot.define do
  factory :benchkiller_tag, class: 'Benchkiller::Tag' do
    title { generate :string }

    factory :benchkiller_lookfor_tag, traits: [ :lookfor ]

    trait :lookfor do
      title { :lookfor }
    end
  end
end
