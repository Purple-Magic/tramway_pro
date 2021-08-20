require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("http://localhost:9000/sendMessage")

header = {'Content-Type': 'text/json'}
body = {
  botToken: '1468112382:AAEebxrV8YNkcZYOy3ium7aN066LEAe7Mpk',
  from: { id: 'hui', first_name: 'HUI', username: 'PIZDA' },
  chat: {
    id: 'HUI-CHAT',
    title: 'HUI-TITLE',
    first_name: 'HUI_NAME',
    username: 'HUI_USERNAME'
  },
  date: Time.now.to_i,
  text: '/start'
}

# Create the HTTP objects
http = Net::HTTP.new(uri.host, uri.port)
response = http.post(uri.path, body.to_query)
puts response.body
