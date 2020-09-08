# frozen_string_literal: true

FactoryBot.define do
  factory :unity, class: Tramway::Conference::Unity do
    title
    phone { generate :phone }
    address { generate :address }
    latitude { generate :latitude }
    longtitude { generate :longtitude }
  end
end
