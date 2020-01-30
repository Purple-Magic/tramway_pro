# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Testing environment' do
  describe 'working' do
    it 'should just run test' do
      expect(true).to be_truthy
    end
  end
end
