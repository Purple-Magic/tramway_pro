class Youtube::TokensService < ApplicationService
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def call
    response = HTTParty.post(
      'https://accounts.google.com/o/oauth2/token',
      body: {
        client_id: ENV['YT_CLIENT_ID'],
        client_secret: ENV['YT_CLIENT_SECRET'],
        grant_type: 'authorization_code',
        code: Youtube::Account.last.authorization_code,
        redirect_uri: 'https://it-way.pro/youtube-callback'
      },
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    )
    body = JSON.parse response.body

    if response.code == 200
      account.update! access_token: body['access_token']
    else
      raise "Error: #{body}"
    end
  end
end
