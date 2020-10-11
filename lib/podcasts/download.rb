require 'rss'
require 'open-uri'

module Podcasts
  module Download
    class << self
      def run
        podcasts = Podcast.active
        podcasts.each do |podcast|
          url = podcast.feed_url
          open(url) do |rss|
            feed = RSS::Parser.parse(rss)
            feed.items.each do |item|
              episode = Episode.find_or_initialize_by season: item.season, number: item.number
              Episode::EPISODE_ATTRIBUTES.each do |attr|
                if episode.id.present?
                  unless episode.send(attr) == item.send(attr)
                    episode.send "#{attr}=", item.send(attr)
                  end
                else
                  episode.send "#{attr}=", item.send(attr)
                end
                episode.save!
              end
            end
          end 
        end
      end
    end
  end
end
