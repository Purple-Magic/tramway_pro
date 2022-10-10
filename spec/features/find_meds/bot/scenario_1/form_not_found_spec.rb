# frozen_string_literal: true

require 'rails_helper'
require_relative './shared/scenario_1/success'
require_relative './shared/scenario_1/failure'
require_relative './shared/scenario_1/error'

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
    include_context 'FindMeds Scenario 1 Error'

    let!(:bot_leopold) { Bot.find_by(id: 9).present? ? Bot.find(9) : create(:leopold_bot) }

    describe 'Form Not Found' do
      context 'Saving feedback' do
        it 'returns not found message' do
          push_search_medicine_button
          type_existing_medicine
          type_existing_company
          type_not_existing_form
          type_feedback
        end
      end

      context 'Returning to the beginning' do
        it 'returns the start message' do
          push_search_medicine_button
          type_existing_medicine
          type_existing_company
          type_not_existing_form
          push_to_beginning_button
        end
      end
    end

    describe 'Not forms' do
      context 'Saving feedback' do
        it 'returns not found message' do
          find_meds_airtable_stub_request table: :companies, id: 'recBayerAG'

          push_search_medicine_button
          type_existing_medicine(medicine: 'Цикло-Прогинова', companies: ['BAYER, AG'])
          type_existing_company_for_medicine_without_forms(company: 'BAYER, AG')
          type_feedback
        end
      end

      context 'Returning to the beginning' do
        it 'returns the start message' do
          find_meds_airtable_stub_request table: :companies, id: 'recBayerAG'

          push_search_medicine_button
          type_existing_medicine(medicine: 'Цикло-Прогинова', companies: ['BAYER, AG'])
          type_existing_company_for_medicine_without_forms(company: 'BAYER, AG')
          push_to_beginning_button
        end
      end
    end
  end
end
