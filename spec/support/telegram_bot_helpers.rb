# frozen_string_literal: true

module TelegramBotHelpers
  def send_message_stub_request(body:)
    stub_request(:post, "https://api.telegram.org/bot#{bot_record.token}/sendMessage").with(
      headers: stub_headers,
      body: body
    ).to_return stub_response
  end

  def send_markdown_message_stub_request(body:)
    stub_request(:post, "https://api.telegram.org/bot#{bot_record.token}/sendMessage").with(
      headers: stub_headers,
      body: body.merge(parse_mode: 'markdown')
    ).to_return stub_response
  end

  def stub_headers
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'User-Agent' => 'Faraday v1.5.1'
    }
  end

  def stub_response
    { status: 200, body: '', headers: {} }
  end

  def reply_markup(keyboard)
    {
      keyboard: [keyboard],
      'resize_keyboard' => false,
      'one_time_keyboard' => false,
      'selective' => false
    }.to_json
  end

  def inline_keyboard(keyboard)
    buttons = keyboard.map do |button|
      [
        {
          text: button.first,
          callback_data: button.second[:data].to_json
        }
      ]
    end
    {
      inline_keyboard: buttons
    }.to_json
  end
end
