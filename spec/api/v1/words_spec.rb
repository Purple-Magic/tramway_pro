require 'rails_helper'

RSpec.describe 'Index word' do
  describe 'GET /api/v1/words/:id' do
    context 'get words' do
      let(:words) { create_list :word, 10 }

      it 'returns success' do
        get '/api/v1/words'
        expect(response.status).to eq 200
      end

      it 'returns words' do
        get '/api/v1/words'
        expect(json_response).to json_api_collection(words)
      end
    end
  end
end
