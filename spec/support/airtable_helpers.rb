module AirtableHelpers
  RESPONSES = {
    collections: {
      names: {
        "records": [
          {
            "id": 'finlepcin_id',
            "createdTime": DateTime.now - 2.days,
            "fields": {
              "Name": "Финлепсин Ретард"
            }
          }
        ]
      },
      main: {
        "records": [
          {
            "id": "rec0Fqy4fYDUibmuQ",
            "createdTime": DateTime.now - 2.days,
            "fields": {
              'Название': "Финлепсин Ретард \"Teva Pharmaceutical Industries, Ltd.\" carbamazepine  концентрация 400 мг",
              "medicine_name": [
                "finlepcin_id"
              ],
            }
          },
          {
            "id": "rec0Fqy4fYDUibmu1",
            "createdTime": DateTime.now - 2.days,
            "fields": {
              'Название':"Финлепсин Ретард \"Teva Pharmaceutical Industries, Ltd.\" carbamazepine  концентрация 200 мг",
              "medicine_name": [
                "finlepcin_id"
              ],
            }
          }
        ]
      }
    },
    items: {
      main: {
        "id": "rec0Fqy4fYDUibmuQ",
        fields: {
          separable_dosage: 'нельзя делить'
        }
      }
    }
  }

  def airtable_collection_stub_request(base:, table:)
    response = RESPONSES[:collection][table]
    raise "You should add collection response for table #{table} in spec/support/airtable_helpers.rb" unless response.present?

    stub_request(:get, build_url(base: base, table: table)).
      with(headers).to_return(status: 200, body: response.to_json, headers: {})
  end

  def airtable_item_stub_request(base:, table:, id:)
    response = RESPONSES[:items][table]
    raise "You should add items  response for table #{table} in spec/support/airtable_helpers.rb" unless response.present?

    stub_request(:get, build_url(base: base, table: table, id: id)).
      with(headers).to_return(status: 200, body: response.to_json, headers: {})
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
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>"Bearer #{ENV['AIR_TABLE_API_KEY']}",
        'Connection'=>'keep-alive',
        'Keep-Alive'=>'30',
        'User-Agent'=>'Airrecord/1.0.10',
        'X-Api-Version'=>'0.1.0'
      }
    }
  end
end
