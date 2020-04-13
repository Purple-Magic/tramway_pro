# frozen_string_literal: true

require 'rails_helper'

describe 'SportSchool: Show main page with events' do
  before do
    landing_page = create :page, page_type: :main, view_state: :published, project_id: sportschool_ulsk_id
    create :block, project_id: sportschool_ulsk_id, block_type: :just_text, view_state: :published, page: landing_page
  end
  before { move_host_to sportschool_ulsk_host }

  it 'should show main page' do
    visit '/'

    expect(page).to have_content Tramway::Landing::Block.where(project_id: sportschool_ulsk_id).last.title
  end
end
