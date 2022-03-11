# frozen_string_literal: true

FactoryBot.define do
  factory :podcast_episode, class: 'Podcast::Episode' do
    title
    number { generate :integer }
    podcast
    cover { generate :image_as_file }
    ready_file { generate :sound_as_file }
  end
end
