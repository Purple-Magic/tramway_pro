# frozen_string_literal: true

require 'rails_helper'

describe 'Benchkiller regions' do
  before do
    host! benchkiller_host
  end

  let(:benchkiller_user) { create :benchkiller_user, password: '123456789' }
  let(:headers) do
    post '/benchkiller/api/user_tokens', params: { auth: { login: benchkiller_user.username, password: '123456789' } }
    token = json_response[:auth_token][:token]
    { Authorization: "Bearer #{token}" }
  end
  let!(:bot_record) { create_benchkiller_bot }

  describe 'Index' do
    before do
      10.times do
        company_name = generate :company_name

        send_message_stub_request body: {
          chat_id: BotTelegram::BenchkillerBot::ADMIN_COMPANIES_CHAT_ID,
          text: "Новая компания #{company_name}. Пользователь пока заполняет данные."
        }

        create :benchkiller_company, title: company_name
      end
    end

    describe 'Authorized' do
      it 'returns success response' do
        get '/benchkiller/api/regions', headers: headers

        expect(response.status).to eq 200
      end

      it 'returns regions collection' do
        get '/benchkiller/api/regions', headers: headers

        expect(json_response).to include_json(
          data: regions.map { |region| { 'id' => region, 'type' => 'strings' } }
        )
      end
    end

    describe 'Unauthorized' do
      it 'returns errors response' do
        get '/benchkiller/api/regions'

        expect(response.status).to eq 401
      end
    end
  end
end
