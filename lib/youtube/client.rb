# frozen_string_literal: true

require 'faraday'

module Youtube::Client
  API_URL = 'https://www.googleapis.com/youtube/v3/videos?part=id%2C+snippet'

  def video_info(id)
    url = "#{API_URL}&id=#{id}&key=#{Rails.application.secrets.YOUTUBE_API_KEY}"
    response = JSON.parse(Faraday.get(url).body).with_indifferent_access
    snippet = response[:items].first[:snippet]

    {
      title: snippet[:title],
      description: snippet[:description],
      preview: snippet[:thumbnails][:maxres][:url]
    }
  end
end
