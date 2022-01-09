require 'rails_helper'

RSpec.describe 'Post generate token', type: :feature do
  describe 'POST /benchkiller/api/user_tokens' do
    let(:benchkiller_user) { create :benchkiller_user, password: '123456789' }

    before do
      host! benchkiller_host
    end

    it 'returns created status' do
      post '/benchkiller/api/user_tokens', params: { auth: { login: benchkiller_user.username, password: '123456789' }  }

      expect(response[:status]).to eq 200
    end
    
    it 'returns token' do
      post '/benchkiller/api/user_tokens', params: { auth: { login: benchkiller_user.username, password: '123456789' }  }

      expect(json_response[:auth_token].present?).to be_truthy
      expect(json_response[:benchkiller_user]).to include_json({ username: benchkiller_user.username, uuid: benchkiller_user.uuid })
    end
  end
end
