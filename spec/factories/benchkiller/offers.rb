FactoryBot.define do
  factory :benchkiller_offer, class: 'Benchkiller::Offer' do
    message { create :bot_telegram_message }
    approval_state { :approved }

    factory :benchkiller_lookfor_offer, traits: [ :lookfor ]

    trait :lookfor do
      after :create do |offer|
        tag = Benchkiller::Tag.find_or_create_by title: :lookfor
        offer.tags << tag
        offer.save!
      end
    end
  end
end
