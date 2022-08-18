# frozen_string_literal: true

module AirtableHelpers
  RESPONSES = {
    collections: {
      names: {
        records: [
          {
            id: 'finlepcin_id',
            fields: {
              Name: 'Финлепсин Ретард'
            }
          }
        ]
      },
      main: {
        records: [
          {
            id: 'rec0Fqy4fYDUibmuQ',
            fields: {
              'Название': 'Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 400 мг',
              medicine_name: [
                'finlepcin_id'
              ],
              intersection_and_substance: [
                'reccJ82ScIlm1tOxC',
                'carbamazepine концентрация 400 мг'
              ],
              form: [
                'Таб.пролонгированного действия'
              ]
            }
          },
          {
            id: 'rec0Fqy4fYDUibmu1',
            fields: {
              'Название': 'Финлепсин Ретард "Teva Pharmaceutical Industries, Ltd." carbamazepine  концентрация 200 мг',
              medicine_name: [
                'finlepcin_id'
              ],
              intersection_and_substance: [
                'reccJ82ScIlm1tOxC',
                'carbamazepine концентрация 200 мг'
              ],
              form: [
                'Таб.пролонгированного действия'
              ]
            }
          },
          {
            id: SecureRandom.hex(8),
            fields: {
              'Название': 'Тегретол',
              medicine_name: [
                'tegretol_id'
              ],
              intersection_and_substance: [
                'reccJ82ScIlm1tOxC',
                'carbamazepine концентрация 400 мг'
              ],
              form: [
                'Таб.пролонгированного действия'
              ],
              company: ["receQeH2nuPmxUA7P"]
            }
          }
        ]
      }
    },
    items: {
      main: {
        id: 'rec0Fqy4fYDUibmuQ',
        fields: {
          separable_dosage: 'нельзя делить',
          medicine_name: [
            'finlepcin_id'
          ],
          intersection_and_substance: [
            'reccJ82ScIlm1tOxC',
            'carbamazepine концентрация 400 мг'
          ],
          form: [
            'Таб.пролонгированного действия'
          ]
        }
      },
      companies: {
        "id": "receQeH2nuPmxUA7P",
        "fields": {
          "Name": "NOVARTIS FARMA, S.p.A.",
        }
      }
    }
  }.freeze

  def airtable_collection_stub_request(base:, table:)
    response = RESPONSES[:collections][table]
    unless response.present?
      raise "You should add collection response for table #{table} in spec/support/airtable_helpers.rb"
    end

    stub_request(:get, build_airtable_url(base: base, table: table))
      .with(airtable_headers).to_return(status: 200, body: response.to_json, headers: {})
  end

  def airtable_item_stub_request(base:, table:, id:)
    response = RESPONSES[:items][table]
    unless response.present?
      raise "You should add items  response for table #{table} in spec/support/airtable_helpers.rb"
    end

    stub_request(:get, build_airtable_url(base: base, table: table, id: id))
      .with(airtable_headers).to_return(status: 200, body: response.to_json, headers: {})
  end

  private

  def build_airtable_url(base:, table:, id: nil)
    url = "https://api.airtable.com/v0/#{base}/#{table}"
    url += "/#{id}" if id.present?
    url
  end

  def airtable_headers
    {
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => "Bearer #{ENV['AIR_TABLE_API_KEY']}",
        'Connection' => 'keep-alive',
        'Keep-Alive' => '30',
        'User-Agent' => 'Airrecord/1.0.10',
        'X-Api-Version' => '0.1.0'
      }
    }
  end
end
