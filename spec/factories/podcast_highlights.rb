# frozen_string_literal: true

FactoryBot.define do
  factory :podcast_highlight, class: 'Podcast::Highlight' do
    podcast
    time
  end
end
