# frozen_string_literal: true

require 'rails_helper'
require_relative './shared/scenario_1/success'

describe 'BotTelegram::FindMedsBot' do
  let!(:bot_record) { create :find_meds_bot }
  let(:chat) { create :bot_telegram_private_chat, bot: bot_record }
  let(:message_object) { create :bot_telegram_message }

  context 'Scenario 1' do
    include_context 'FindMeds Scenario 1 Success'

    context 'Main' do

      describe 'Medicine Found' do
        it 'search medicine by name' do
          push_search_medicine_button
          type_existing_medicine
          type_existing_company
          type_existing_form
          type_existing_concentration
        end
      end
    end

    # context 'Various concentrations' do
    #   context 'Concentrated solution in milligrams per milliliter:' do
    #     describe 'Medicine Found' do
    #       let(:medicine_button_message) { build :telegram_message, text: 'Трилептал' }

    #       it 'search medicine by name' do
    #         push_search_medicine_button
    #         type_existing_medicine
    #         type_existing_company
    #         type_existing_form
    #         type_existing_concentration
    #       end
    #     end
    #   end
    # end
  end
end
