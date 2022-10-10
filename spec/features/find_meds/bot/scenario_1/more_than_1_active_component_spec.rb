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

    describe 'More than one active components' do
      context 'Saving feedback' do
        let!(:bot_leopold) { create :leopold_bot }

        it 'returns not found message' do
          find_meds_airtable_stub_request table: :companies, id: 'recKanonPharma'

          push_search_medicine_button
          type_existing_medicine(medicine: 'Бензиэль', companies: ['КАНОНФАРМА ПРОДАКШН, ЗАО'])
          type_existing_company(company: 'КАНОНФАРМА ПРОДАКШН, ЗАО', forms: ['Таблетка'])
          type_existing_form_for_medicine_with_two_or_more_components(form: 'Таблетка')
          type_feedback
        end
      end

      context 'Returning to the beginning' do
        it 'returns the start message' do
          find_meds_airtable_stub_request table: :companies, id: 'recKanonPharma'

          push_search_medicine_button
          type_existing_medicine(medicine: 'Бензиэль', companies: ['КАНОНФАРМА ПРОДАКШН, ЗАО'])
          type_existing_company(company: 'КАНОНФАРМА ПРОДАКШН, ЗАО', forms: ['Таблетка'])
          type_existing_form_for_medicine_with_two_or_more_components(form: 'Таблетка')
          push_to_beginning_button
        end
      end
    end
  end
end
