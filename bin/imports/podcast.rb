require 'rss'
require 'httparty'

response = HTTParty.get 'https://feeds.redcircle.com/5a51ca0b-c930-480a-85f4-94a5f2190530'

feed = RSS::Parser.parse response.body

feed.items.each do |item|
  number = item.title.match(/Episode \d+/).to_s.sub('Episode ', '').to_i
  if number < 71
    params = {
      number: number,
      public_title: item.title,
      description: item.description,
      publish_date: item.pubDate
    }
    Podcast::Episode.create! podcast_id: 2, project_id: 9, **params
  end
end
