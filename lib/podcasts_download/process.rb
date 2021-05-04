# frozen_string_literal: true

require 'rss'
require 'open-uri'

module PodcastsDownload::Process
  class << self
    IT_WAY_PROJECT_ID = 2

    def item_attribute(item, attribute_name)
      attribute_name = case attribute_name
                       when :number
                         'episode'
                       when :published_at
                         'pubDate'
                       when :file_url
                        'enclosure'
                       else
                         attribute_name.to_s
                       end
      attribute = item.children.select { |attr| attr.name == attribute_name }.first
      return unless attribute.present?

      case attribute_name
      when 'image'
        attribute.attributes['href'].value
      when 'enclosure'
        attribute.attributes['url'].value
      else
        attribute.children.first.content
      end
    end

    def run
      podcasts = Podcast.active.where project_id: IT_WAY_PROJECT_ID
      podcasts.each do |podcast|
        url = podcast.feed_url
        open(url) do |rss| #FIXME The use of URI.open is a serious security risk
          xml = Nokogiri::XML(rss.read)
          channel = xml.children.first.children[1]
          items = channel.children.map do |node|
            node if node.respond_to?(:name) && node.name == 'item'
          end.compact.reverse
          items.each do |item|
            guid = item_attribute item, 'guid'
            episode = Podcast::Episode.find_or_initialize_by guid: guid, project_id: IT_WAY_PROJECT_ID
            Podcast::Episode::EPISODE_ATTRIBUTES.each do |attr|
              value = item_attribute item, attr
              if episode.id.present?
                episode.send "#{attr}=", value unless episode.send(attr) == value
              else
                episode.send "#{attr}=", value
                episode.podcast_id = podcast.id unless episode.podcast_id.present?
              end
              episode.save!
            end
          end
        end
      end
    end
  end
end

PodcastsDownload::Process.run
