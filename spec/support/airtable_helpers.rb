# frozen_string_literal: true

module AirtableHelpers
  def find_meds_airtable_stub_request(table:, id: nil)
    airtable_stub_request(
      base: ::BotTelegram::FindMedsBot::Tables::ApplicationTable.base_key,
      table: table,
      id: id
    )
  end

  def airtable_stub_request(base:, table:, id:)
    response = response(table: table, id: id)
    unless response.present?
      raise "You should add collection response for table #{table} in spec/support/airtable_helpers.rb"
    end

    stub_request(:get, build_airtable_url(base: base, table: table, id: id))
      .with(airtable_headers).to_return(status: 200, body: response.to_json, headers: {})
  end

  private

  def build_airtable_url(base:, table:, id:)
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

  def response(table:, id: nil)
    if id.present?
      single_record_response table: table, id: id
    else
      collection_response table: table
    end
  end

  def single_record_response(table:, id:)
    record = base[table].select do |item|
      item[:id] == id
    end.first

    transform_record record
  end

  def collection_response(table:)
    {
      records: base[table].map do |record|
        transform_record record
      end
    }
  end

  def base
    @find_meds_base ||= YAML.load_file(Rails.root.join('spec', 'support', 'find_meds', 'base.yml')).with_indifferent_access
  end

  def transform_record(record)
    {
      id: record[:id],
      fields: record.except(:id)
    }
  end

end
