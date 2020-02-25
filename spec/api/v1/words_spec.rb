# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Index word' do
  describe 'GET /api/v1/words/:id' do
    context 'get words' do
      let(:words) { create_list :word, 10 }
      before do
        set_host 'http://it-way.test:3000'
      end

      it 'returns success' do
        get '/api/v1/records?model=Word'
        expect(response.status).to eq 200
      end

      it 'returns words' do
        get '/api/v1/records?model=Word'
        expect(json_response).to json_api_collection(words)
      end
    end
  end
end
