# frozen_string_literal: true

require 'rails_helper'

describe 'Show block' do
  before { create :block }

  it 'should show block' do
    visit '/admin'
    fill_in 'Email', with: 'admin@email.com'
    fill_in 'Password', with: '123456'
    click_on 'Войти', class: 'btn-success'

    last_block = create :block
    click_on 'Блок'
    click_on last_block.title

    expect(page).to have_content last_block.title
  end
end
