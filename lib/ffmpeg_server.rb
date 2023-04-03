require 'json'
require 'bundler/inline'

gemfile(true) do
  source "https://rubygems.org"

  gem 'webrick'
end

require 'webrick'

class FFmpegServer < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    command = JSON.parse(request.body)['command']
    begin
      system(command)
      response.status = 200
      response.body = 'Success\n'
    rescue => e
      response.status = 500
      response.body = "Error: #{e}\n"
    end
  end
end

server = WEBrick::HTTPServer.new(Port: 8080)
server.mount '/', FFmpegServer
trap('INT') { server.shutdown }
server.start
