# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: Tramway::User::User do
    email
    password
    role { :admin }
  end

  factory :admin_admin_attributes, class: Tramway::User::User do
    email
    password
    first_name { generate :string }
    last_name { generate :string }
    role { Tramway::User::User.role.values.sample.text }
  end
end
