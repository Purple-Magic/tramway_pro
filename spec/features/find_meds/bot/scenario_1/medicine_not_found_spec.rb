# frozen_string_literal: true

require 'rails_helper'
require_relative './shared/scenario_1/success'
require_relative './shared/scenario_1/failure'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }
  before do
    create :find_meds_feedback
  end

  context 'Scenario 1' do
    include_context 'FindMeds Scenario 1 Success'
    include_context 'FindMeds Scenario 1 Failure'

    describe 'Medicine Not Found' do

      context 'Saving feedback' do
        let!(:bot_leopold) { create :leopold_bot }

        it 'returns not found message and saves feedback' do
          push_search_medicine_button
          type_not_existing_medicine
          type_feedback
        end
      end

      context 'Returning to the beginning' do
        it 'returns the start message' do
          push_search_medicine_button
          type_not_existing_medicine
          push_to_beginning_button
        end
      end
    end
  end
end
