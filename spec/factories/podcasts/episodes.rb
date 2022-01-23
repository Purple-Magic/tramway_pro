FactoryBot.define do
  factory :podcast_episode, class: 'Podcast::Episode' do
    title
    number { generate :integer }
  end
end
