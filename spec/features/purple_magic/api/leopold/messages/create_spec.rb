# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post generate token', type: :feature do
  describe 'POST /purple_magic/api/v1/leopold/messages' do
    before do
      host! purple_magic_host
    end

    let!(:product) { create :product }
    let!(:bot_record) { create :leopold_bot }

    it 'returns created status' do
      product.reload

      stub = send_message_stub_request body: {
        chat_id: product.chat_id,
        text: 'Test message',
        parse_mode: 'markdown'
      }

      post '/purple_magic/api/v1/leopold/messages',
        params: {
          engine: 'Product',
          id: product.uuid,
          message: 'Test message'
        }

      expect(stub).to have_been_requested
    end
  end
end
