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
          push_yes_button_on_reinforcement
          push_bot_helped_me_on_last_step
        end
      end
    end

    context 'Various concentrations' do
      context 'Concentrated solution in milligrams per milliliter:' do
        describe 'Medicine Found' do
          it 'search medicine by name' do
            push_search_medicine_button
            type_existing_medicine(medicine: 'Трилептал', companies: ['NOVARTIS FARMA, S.p.A.'])
            type_existing_company(forms: ['Таб., покр. пленочной оболочкой', 'Суспензия для приема внутрь'])
            type_existing_form(
              form: 'Суспензия для приема внутрь',
              component: 'oxcarbazepine',
              concentrations: ['60 мг/мл, 250 мл', '60 мг/мл, 100 мл']
            )
            type_existing_concentration(
              concentration: '60 мг/мл, 250 мл',
              medicine: 'Трилептал "NOVARTIS FARMA, S.p.A." oxcarbazepine  концентрация 150 мг'
            )
            push_yes_button_on_reinforcement(medicine: 'Трилептал "NOVARTIS FARMA, S.p.A." oxcarbazepine  концентрация 150 мг')
            push_bot_helped_me_on_last_step
          end
        end
      end
    end
  end
end
