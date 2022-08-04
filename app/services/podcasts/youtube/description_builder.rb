class Podcasts::Youtube::DescriptionBuilder < ApplicationService
  include ActionView::Helpers::OutputSafetyHelper

  attr_reader :episode, :format, :youtube_description

  def initialize(episode, format:)
    @episode = episode
    @format = format
  end

  def call
    @youtube_description = ''

    section :header
    section :starring
    section :guests if episode.model.with_guests?
    section :minor if episode.model.with_minor?
    section :topics
    section :links if episode.links.any?
    static_content

    @youtube_description
  end

  private

  def end_line
    case format
    when :html
      '<br/>'
    when :text
      "\n"
    end
  end

  def section(name)
    @youtube_description += send(name).join(end_line) + end_line + end_line
  end

  def header
    [ I18n.t('podcast_engine.youtube.description.you_can_find_us') ] + episode.instances.map do |instance|
      "* #{instance.service.capitalize} #{instance.shortened_url}"
    end
  end

  def starring
    people :main
  end

  def guests
    people :guest
  end

  def minor
    people :minor
  end

  def people(role)
    [ I18n.t("podcast_engine.youtube.description.stars.#{role}") ] + episode.model.stars.send(role).map do |star|
      "* @#{star.star.nickname} #{star.link}\n"
    end
  end

  def topics
    topics_list = if episode.topics.any?
                    episode.topics.map do |topic|
                      "* #{topic.title} #{topic.link}"
                    end
                  else
                    [ raw(episode.model.description) ]
                  end
    [ I18n.t('podcast_engine.youtube.description.topics') ] + topics_list
  end

  def links
    [ I18n.t('podcast_engine.youtube.description.links') ] + episode.links.map do |link|
      "* #{link.title} #{link.link}"
    end
  end

  def static_content
    footer = episode.podcast.youtube_footer
    if footer.present? 
      @youtube_description += case format
                              when :html
                                footer.gsub("\n", '<br/>')
                              when :text
                                footer
                              end
    end
  end
end
