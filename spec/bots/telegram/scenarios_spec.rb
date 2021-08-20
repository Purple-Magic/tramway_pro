require 'rails_helper'

describe 'Scenario Bots', type: :feature do
  it 'go off the scenario' do
    uri = URI.parse("http://localhost:9000/sendMessage")

    user_message = '/start'
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
      text: user_message
    }

    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri.path, body.to_query)
    expect(response.code).to eq '200'
    
    sleep 1

    last_bot_message = BotTelegram::Message.where(sender: :bot).last.text
    bot = Bot.find 5
    needed_step = if user_message == '/start'
                    bot.steps.find_by(name: :start)
                  else
                  end
    expect(last_bot_message).to eq needed_step.text
  end
end
