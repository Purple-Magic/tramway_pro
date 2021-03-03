# frozen_string_literal: true

require 'rails_helper'

describe 'Create podcast highlight' do
  let!(:attributes) { attributes_for :podcast_highlight }

  before { create :page, slug: 'podcast_highlight', view: 'podcast_highlight', project_id: it_way_id, view_state: :published }

  it 'IT Ways hould create podcast highlight' do
    move_host_to it_way_host
    count = Podcast::Highlight.count
    visit '/page/podcast_highlight'

    find('#playButton').click
    5.times do |index|
      sleep 1
      click_on 'Сохранить'
    end
    expect(Podcast::Highlight.count).to eq(count + 5)
  end
end
