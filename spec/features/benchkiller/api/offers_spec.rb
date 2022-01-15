# frozen_string_literal: true

require 'rails_helper'

describe 'Benchkiller Offers' do
  before do
    host! benchkiller_host
  end

  let(:benchkiller_user) { create :benchkiller_user, password: '123456789' }
  let(:headers) do
    post '/benchkiller/api/user_tokens', params: { auth: { login: benchkiller_user.username, password: '123456789' } }
    token = json_response[:auth_token][:token]
    { Authorization: "Bearer #{token}" }
  end

  describe 'Index' do
    before do
      10.times do
        create :benchkiller_lookfor_offer
      end
    end

    describe 'Authorized' do
      it 'returns success response' do
        get '/benchkiller/api/offers', headers: headers

        expect(response.status).to eq 200
      end

      it 'returns offers collection' do
        get '/benchkiller/api/offers', headers: headers

        expect(json_response).to include_json(json_api_collection(Benchkiller::Offer.last(10).reverse))
      end
    end

    describe 'Unauthorized' do
      it 'returns errors response' do
        get '/benchkiller/api/offers'

        expect(response.status).to eq 401
      end
    end
  end
end
