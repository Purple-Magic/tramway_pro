# frozen_string_literal: true

require 'rails_helper'

describe 'IT Way: Show main page with events' do
  before do
    landing_page = create :page, page_type: :main, view_state: :published, project_id: it_way_id
    create :block, block_type: :header, project_id: it_way_id, view_state: :published, page: landing_page
  end
  before { move_host_to it_way_host }
  let!(:open_event) { create :event, reach: :open }
  let!(:closed_event) { create :event, reach: :closed }

  it 'should not show main page with started campaign' do
    visit '/'

    expect(page).to have_content open_event.title
    expect(page).not_to have_content closed_event.title
  end
end
