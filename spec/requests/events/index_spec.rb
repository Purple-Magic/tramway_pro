# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Index event', type: :feature do
  describe "GET /api/v1/records?model=Event" do
    before { create_list :event, 5 }

    it 'returns status' do
      get '/api/v1/records', params: { model: 'Event' }, headers: headers
      expect(response.status).to eq 200
    end
  end
end
