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
      describe 'One medicine Found' do
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

      describe 'Three medicine Found' do
        it 'search medicine by name' do
          find_meds_airtable_stub_request table: :companies, id: :recMerck

          push_search_medicine_button
          type_existing_medicine(medicine: 'Эутирокс', companies: ['MERCK, KGaA'])
          type_existing_company(company: 'MERCK, KGaA', forms: ['Таблетка'])
          type_existing_form(
            form: 'Таблетка',
            buttons_collection: [['0.1 мг', '0.2 мг', '0.3 мг', '0.4 мг'], ['0.5 мг', '0.6 мг']],
            component: 'levothyroxine sodium',
            
          )
          type_existing_concentration(
            concentration: '0.1 мг',
            medicine: 'Эутирокс "MERCK, KGaA" levothyroxine sodium  концентрация 0.1 мг'
          )
          push_yes_button_on_reinforcement(
            medicines: [
              'L-Тироксин Берлин-Хеми "BERLIN-CHEMIE, AG " levothyroxine sodium  концентрация 0.1 мг',
              'L-тироксин "ОЗОН, ООО" levothyroxine sodium  концентрация 0.1 мг',
              'Эутирокс "MERCK, KGaA" levothyroxine sodium  концентрация 0.1 мг'
            ]
          )
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
              buttons_collection: [['60 мг/мл, 250 мл', '60 мг/мл, 100 мл']]
            )
            type_existing_concentration(
              concentration: '60 мг/мл, 250 мл',
              medicine: 'Трилептал "NOVARTIS FARMA, S.p.A." oxcarbazepine  концентрация 150 мг'
            )
            push_yes_button_on_reinforcement(
              medicines: ['Трилептал "NOVARTIS FARMA, S.p.A." oxcarbazepine  концентрация 150 мг']
            )
            push_bot_helped_me_on_last_step
          end
        end
      end
    end
  end
end
