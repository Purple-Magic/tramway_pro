require 'rails_helper'

describe 'Scenario Bots', type: :feature do
  it 'go off the scenario' do
    uri = URI.parse("http://localhost:9000/sendMessage")

    body = {
      botToken: '1468112382:AAEebxrV8YNkcZYOy3ium7aN066LEAe7Mpk',
      from: { id: 'hui', first_name: 'HUI', username: 'PIZDA' },
      chat: {
        id: 'HUI-CHAT',
        title: 'HUI-TITLE',
        first_name: 'HUI_NAME',
        username: 'PIZDA'
      },
      date: Time.now.to_i,
      text: '/start'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri.path, body.to_query)
  end
end
