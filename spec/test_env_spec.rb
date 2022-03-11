# frozen_string_literal: true

require 'rails_helper'

describe 'Testing environment', type: :feature do
  describe 'working' do
    it 'should just run test' do
      expect(true).to be_truthy
    end
  end

  describe 'test browser' do
    it 'should default page' do
      move_host_to 'localhost'

      visit '/'

      expect(page).to be_truthy
    end
  end
end
