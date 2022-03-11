# frozen_string_literal: true

FactoryBot.define do
  factory :podcast_episodes_part, class: 'Podcast::Episodes::Part' do
    episode { create :podcast_episode }
    begin_time { generate :timestamp }
    end_time { generate :timestamp }
  end
end
