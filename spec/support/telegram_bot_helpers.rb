module TelegramBotHelpers
  def send_message_stub_request(body:)
    stub_request(:post, "https://api.telegram.org/bot#{bot_record.token}/sendMessage").with(
      headers: headers,
      body: body.merge(parse_mode: 'markdown')
    ).to_return response
  end

  def headers
    {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'Faraday v1.5.1'
    }
  end

  def response
    { status: 200, body: "", headers: {} }
  end

  def reply_markup(keyboard)
    {
      "keyboard": [keyboard],
      "resize_keyboard" => false,
      "one_time_keyboard" => false,
      "selective" => false
    }.to_json
  end
end
