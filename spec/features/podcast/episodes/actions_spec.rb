# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe 'Actions' do
  before do
    move_host_to red_magic_host
    stub_request(:get, 'https://cdn.jsdelivr.net/npm/simple-icons@3.13.0/icons/youtube.svg')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: '', headers: {})
  end

  let!(:episode) do
    podcast = create :podcast, project_id: red_magic_id, podcast_type: :sample
    create :podcast_episode, podcast: podcast, project_id: red_magic_id
  end

  Podcast::Episode::WORKER_EVENTS.each do |worker_event|
    it "runs #{worker_event[:worker]} worker" do
      visit '/admin'
      fill_in 'Email', with: "admin#{red_magic_id}@email.com"
      fill_in 'Пароль', with: '123456'
      click_on 'Войти', class: 'btn-success'

      click_on 'Подкасты'
      click_on episode.podcast.title
      click_on episode.title

      click_on_link_by_href Rails.application.routes.url_helpers.red_magic_api_v1_podcast_episode_path(episode.id,
        process: worker_event[:event])

      expect("Podcasts::#{worker_event[:worker]}Worker".constantize).to have_enqueued_sidekiq_job(episode.id)
    end
  end
end
