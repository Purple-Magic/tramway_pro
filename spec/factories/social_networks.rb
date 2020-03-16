FactoryBot.define do
  factory :social_network, class: 'Tramway::Profiles::SocialNetwork' do
    title
    uid { generate :string }
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample }
    record_type { Tramway::Profiles::SocialNetwork.record_type.values.sample }
    record_id do
      record_type.constantize.last&.id || create(record_type.underscore).id
    end
  end

  factory :social_network_admin_attributes, class: 'Tramway::Profiles::SocialNetwork' do
    title
    uid { generate :string }
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample.text }
    record do
      record_type = Tramway::Profiles::SocialNetwork.record_type.values.sample
      record_title = record_type.constantize.last&.title || create(record_type.underscore).title
      "#{record_type.constantize.model_name.human} | #{record_title}"
    end
  end

  factory :social_network_admin_add_to_unity_attributes, class: 'Tramway::Profiles::SocialNetwork' do
    title
    uid { generate :string }
    network_name { Tramway::Profiles::SocialNetwork.network_name.values.sample.text }
  end
end
