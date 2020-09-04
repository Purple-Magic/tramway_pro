# frozen_string_literal: true

require 'rails_helper'

describe 'IT Way: Show main page with contacts' do
  before do
    landing_page = create :page, page_type: :main, view_state: :published, project_id: it_way_id
    create :block, block_type: :header, project_id: it_way_id, view_state: :published, page_id: landing_page.id
    create :block, block_type: :contacts, project_id: it_way_id, view_state: :published, page_id: landing_page.id
  end
  before { move_host_to it_way_host }

  it 'should show main page with map' do
    visit '/'
    project =  Tramway::Conference::Unity.last

    expect(page).to have_content project.phone
    expect(page).to have_content project.address
    expect(page.find("#map-container").present?).to be_truthy
  end

  it 'should show main page without map' do
    project =  Tramway::Conference::Unity.last
    project.update!(latitude: nil, longtitude: nil)

    visit '/'

    expect(page).to have_content project.phone
    expect(page).to_not have_css "#map-container"
  end
end
