FactoryBot.define do
  factory :podcast_highlight, class: 'Podcast::Highlight' do
    podcast
    time
  end
end
