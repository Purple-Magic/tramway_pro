# frozen_string_literal: true

require 'rails_helper'

describe 'Show block' do
  before { create :block, project_id: it_way_id }

  it 'should show block' do
    set_host it_way_host
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_block = create :block, project_id: it_way_id
    click_on_dropdown 'Лендинг'
    click_on 'Блоки'
    click_on last_block.title

    expect(page).to have_content last_block.title
  end
end
