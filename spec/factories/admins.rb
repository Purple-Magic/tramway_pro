# frozen_string_literal: true

FactoryBot.define do
  factory :admin, aliases: [:user], class: Tramway::User::User do
    email
    password
    role { :admin }
    first_name { generate :string }
    last_name { generate :string }
    phone

    trait :with_social_networks do
      after :create do |user|
        Tramway::Profiles::SocialNetwork.network_name.each_value do |network|
          create :social_network, network_name: network, record_type: Tramway::User::User, record_id: user.id
        end
      end
    end
  end

  factory :admin_admin_attributes, class: Tramway::User::User do
    email
    password
    first_name { generate :string }
    last_name { generate :string }
    role { Tramway::User::User.role.values.sample.text }
  end
end
