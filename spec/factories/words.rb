FactoryBot.define do
  factory :word do
    main { generate :string }
    synonims do
      [
        generate(:string),
        generate(:string),
        generate(:string),
        generate(:string)
      ]
    end
    description { generate :string }
  end
end
