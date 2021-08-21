require 'bot_helper'

describe 'Scenario Bots', type: :feature do
  before do
    tables = [
      :bots,
      :bot_telegram_scenario_steps,
      :projects
    ]
    username = ENV['USERNAME']
    at = Time.now.strftime('%Y-%m-%d--%H-%M')
    dump = "public-data--#{at}.dump"
    system "scp #{username}@138.68.76.45:/srv/tramway_pro/shared/config/database.yml ./"
    db_config = YAML.load_file('database.yml')
    db_name = db_config['production']['database']
    system 'rm -rf database.yml'
    command = "ssh -t #{username}@138.68.76.45 'pg_dump --column-inserts -a #{tables.map { |table| "-t #{table} " }.join} -Fc --no-acl --no-owner -v #{db_name} > #{dump}'"
    system command
    system "scp #{username}@138.68.76.45:#{dump} #{Rails.root}/tmp/"
    system command
    database_name = Rails.configuration.database_configuration["test"]["database"]
    system "pg_restore -d #{database_name} #{Rails.root}/tmp/#{dump}"
  end

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

    sleep 20
    
    last_bot_message = BotTelegram::Message.where(sender: :bot).last.text
    bot = Bot.find 5
    needed_step = if user_message == '/start'
                    bot.steps.find_by(name: :start)
                  else
                  end
    expect(last_bot_message).to eq needed_step.text
  end
end
