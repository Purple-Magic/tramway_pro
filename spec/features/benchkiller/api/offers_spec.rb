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

      describe 'Search' do
        describe 'Regions' do
          let(:country) { Faker::Address.country }
          let!(:offers) do
            companies = (1..5).to_a.map do
              create :benchkiller_company, regions_to_cooperate: [ country ]
            end
            companies.map do |company|
              telegram_message = create :bot_telegram_message, user: company.users.first.telegram_user
              create :benchkiller_lookfor_offer, message: telegram_message
            end
          end

          it 'returns all 5 offers' do
            get '/benchkiller/api/offers', headers: headers, params: { regions: country }

            offers.each do |offer|
              expect(json_response).to have_content offer.message.text
            end
          end

          it 'returns 0 offers' do
            get '/benchkiller/api/offers', headers: headers, params: { regions: Faker::Address.country }

            offers.each do |offer|
              expect(json_response).not_to have_content offer.message.text
            end
          end
        end
      end

      describe 'Period' do
        before do
          ::Benchkiller::Offer.delete_all
        end

        periods = [
          {
            title: :day,
            unaccepting_value: 2.days.ago
          },
          {
            title: :week,
            unaccepting_value: 2.weeks.ago
          },
          {
            title: :month,
            unaccepting_value: 2.months.ago
          },
          {
            title: :quarter,
            unaccepting_value: 4.months.ago
          }
        ]

        periods.each do |period|
          describe period[:title].to_s.capitalize do
            let!(:offers) do
              (1..5).to_a.map do |index|
                create(:benchkiller_lookfor_offer).tap do |offer|
                  offer.update_column :created_at, 1.hour.ago
                end
              end
            end

            let!(:too_old_offers) do
              (1..5).to_a.map do |index|
                create(:benchkiller_lookfor_offer).tap do |offer|
                  offer.update_column :created_at, period[:unaccepting_value]
                end
              end
            end

            before do
              get '/benchkiller/api/offers', headers: headers, params: { period: period[:title] }
            end

            it 'returns 5 needed offers' do
              offers.each do |offer|
                expect(json_response).to have_content offer.message.text
              end
            end

            it 'does not return 5 too old offers' do
              too_old_offers.each do |offer|
                expect(json_response).not_to have_content offer.message.text
              end
            end
          end
        end

        describe 'Various period' do
          let!(:offers) do
            (1..5).to_a.map do |index|
              create(:benchkiller_lookfor_offer).tap do |offer|
                offer.update_column :created_at, 1.week.ago
              end
            end
          end

          let!(:too_old_offers) do
            (1..5).to_a.map do |index|
              create(:benchkiller_lookfor_offer).tap do |offer|
                offer.update_column :created_at, 5.weeks.ago
              end
            end
          end

          let!(:too_new_offers) do
            (1..5).to_a.map do |index|
              create(:benchkiller_lookfor_offer).tap do |offer|
                offer.update_column :created_at, 1.day.ago
              end
            end
          end


          before do
            get(
              '/benchkiller/api/offers',
              headers: headers,
              params: {
                begin_date: 10.days.ago,
                end_date: 5.days.ago
              }
            )
          end

          it 'returns 5 needed offers' do
            offers.each do |offer|
              expect(json_response).to have_content offer.message.text
            end
          end

          it 'does not return 5 old offers' do
            too_old_offers.each do |offer|
              expect(json_response).not_to have_content offer.message.text
            end
          end

          it 'does not return 5 new offers' do
            too_new_offers.each do |offer|
              expect(json_response).not_to have_content offer.message.text
            end
          end
        end
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
