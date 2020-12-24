# frozen_string_literal: true

FactoryBot.define do
  trait :campaign_started do
    request_collecting_begin_date { (DateTime.now - 1.day).beginning_of_day.change(offset: '+0400') }
    request_collecting_end_date { (DateTime.now + 10.days).beginning_of_day.change(offset: '+0400') }
  end

  factory :event, class: 'Tramway::Event::Event' do
    title { generate :string }
    description { generate :string }
    short_description { generate :string }
    begin_date { (DateTime.now + 1.day).beginning_of_day.change(offset: '+0400') }
    end_date { begin_date + 10.days }
    request_collecting_begin_date { DateTime.now.beginning_of_day.change(offset: '+0400') }
    request_collecting_end_date { DateTime.now.beginning_of_day.change(offset: '+0400') }
    photo { generate :full_hd_image_as_file }

    trait :created_by_admin do
      after :create do |event|
        creation_event = event.audits.where(action: :create).first
        creation_event.update! user_id: create(:admin).id, user_type: Tramway::User::User
      end
    end

    trait :created_by_full_filled_admin do
      after :create do |event|
        creation_event = event.audits.where(action: :create).first
        creation_event.update! user_id: create(:admin, :with_social_networks).id, user_type: Tramway::User::User
      end
    end
  end

  factory :event_admin_attributes, class: 'Tramway::Event::Event' do
    title { generate :string }
    begin_date { DateTime.now.beginning_of_day.change(offset: '+0400') }
    end_date { DateTime.now.beginning_of_day.change(offset: '+0400') }
    request_collecting_begin_date { DateTime.now.beginning_of_day.change(offset: '+0400') }
    request_collecting_end_date { DateTime.now.beginning_of_day.change(offset: '+0400') }
    reach { Tramway::Event::Event.reach.values.sample.text }
    photo { generate :full_hd_image_as_path }
  end
end
