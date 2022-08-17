module AirtableHelpers
  RESPONSES = {
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
  }

  def airtable_stub_request(base:, table:)
    raise "You should add response for table #{table} in spec/support/airtable_helpers.rb" unless RESPONSES[table].present?

    stub_request(:get, "https://api.airtable.com/v0/#{base}/#{table}").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>"Bearer #{ENV['AIR_TABLE_API_KEY']}",
          'Connection'=>'keep-alive',
          'Keep-Alive'=>'30',
          'User-Agent'=>'Airrecord/1.0.10',
          'X-Api-Version'=>'0.1.0'
        }).to_return(status: 200, body: RESPONSES[table].to_json, headers: {})
  end
end
