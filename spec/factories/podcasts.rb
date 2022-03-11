# frozen_string_literal: true

FactoryBot.define do
  factory :podcast, class: 'Podcast' do
    title { generate :string }
    feed_url { generate :url }
    podcast_type { Podcast.podcast_type.values.sample }
  end

  factory :podcast_admin_attributes, class: 'Podcast' do
    title { generate :string }
    feed_url { generate :url }
  end
end
