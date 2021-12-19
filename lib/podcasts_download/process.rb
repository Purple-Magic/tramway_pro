# frozen_string_literal: true

require 'rss'
require 'net/http'
require 'uri'

module PodcastsDownload::Process
  class << self
    RED_MAGIC_PROJECT_ID = 9

    def item_attribute(item, attribute_name)
      naming_file_path = Rails.root.join('lib', 'podcasts_download', 'naming.yml')
      naming = YAML.safe_load(File.open(naming_file_path)).with_indifferent_access[:naming]
      attribute_name = naming[attribute_name].present? ? naming[attribute_name] : attribute_name.to_s
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

    def build_item(item)
      guid = item_attribute item, 'guid'
      episode = Podcast::Episode.find_or_initialize_by guid: guid, project_id: RED_MAGIC_PROJECT_ID
      Podcast::Episode::EPISODE_ATTRIBUTES.each do |attr|
        value = item_attribute item, attr
        if episode.id.present?
          episode.send "#{attr}=", value unless episode.send(attr) == value
        else
          episode.send "#{attr}=", value
        end
        episode.podcast_id = podcast.id unless episode.podcast_id.present?
        episode.save!
      end
    end

    # :reek:ManualDispatch { enabled: false }
    def run
      podcasts = Podcast.where project_id: RED_MAGIC_PROJECT_ID
      podcasts.each do |podcast|
        url = podcast.feed_url
        rss = Net::HTTP.get(URI.parse(url))
        xml = Nokogiri::XML(rss)
        channel = xml.children.first.children[1]
        items = channel.children.map do |node|
          node if node.respond_to?(:name) && node.name == 'item'
        end.compact.reverse
        items.each do |item|
          build_item item
        end
      end
    end
  end
end

PodcastsDownload::Process.run
