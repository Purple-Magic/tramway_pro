# frozen_string_literal: true

FactoryBot.define do
  factory :social_network, class: 'Tramway::Profiles::SocialNetwork' do
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample }
    title { "#{network_name}: #{generate(:string)}" }
    uid { generate :string }
    record_type { Tramway::Profiles::SocialNetwork.record_type.values.sample }
    record_id do
      record_type.constantize.last&.id || create(record_type.underscore.split('/').last).id
    end
  end

  factory :social_network_admin_attributes, class: 'Tramway::Profiles::SocialNetwork' do
    title
    uid { generate :string }
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample.text }
#    record do
#      record_type = Tramway::Profiles::SocialNetwork.record_type.values.sample
#      record = record_type.constantize.last || create(record_type.underscore.split('/').last)
#      record_title = "#{record_type}Decorator".constantize.decorate(record).name
#      "#{record_type.constantize.model_name.human} | #{record_title}"
#    end
  end

  factory :social_network_admin_add_to_unity_attributes, class: 'Tramway::Profiles::SocialNetwork' do
    title
    uid { generate :string }
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample.text }
  end

  factory :social_network_admin_add_to_admin_attributes, class: 'Tramway::Profiles::SocialNetwork' do
    title
    uid { generate :string }
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample.text }
  end
end
