# frozen_string_literal: true

module Podcast::Episodes::DescriptionConcern
  def description_view
    content_tag(:div) do
      stars_list
      guest_list if object.with_guests?
      minor_list if object.with_minor?
      topics_list
      links_list
      static_content
    end
  end

  private

  def stars_list
    concat('Ведущие:')
    concat content_tag :br
    Podcast::StarDecorator.decorate(object.stars.main).each do |star|
      if star.link.present?
        concat link_to "🎙️ #{star.nickname}", star.link
        concat content_tag :br
      else
        concat "🎙️ #{star.nickname}"
        concat content_tag :br
      end
    end
  end

  def guest_list
    concat('Гости:')
    concat content_tag :br
    Podcast::StarDecorator.decorate(object.stars.guest).each do |star|
      if star.link.present?
        concat link_to "🎙️ #{star.nickname}", star.link
        concat content_tag :br
      else
        concat "🎙️ #{star.nickname}"
        concat content_tag :br
      end
    end
  end

  def minor_list
    concat('Эпизодическое участие:')
    concat content_tag :br
    Podcast::StarDecorator.decorate(object.stars.minor).each do |star|
      if star.link.present?
        concat link_to "🎙️ #{star.nickname}", star.link
        concat content_tag :br
      else
        concat "🎙️ #{star.nickname}"
        concat content_tag :br
      end
    end
  end

  def topics_list
    concat(content_tag(:h1) do
      'Темы выпуска'
    end)

    if topics.any?
      topics.each do |topic|
        concat link_to topic.title, topic.link
        concat content_tag :br
      end
    else
      concat raw object.description
    end
  end

  def links_list
    return unless object.links.any?

    concat(content_tag(:h3) do
      'Ссылки'
    end)
    object.links.each do |link|
      concat link_to(link.title, link.link)
      concat content_tag :br
    end
  end

  def static_content
    concat(content_tag(:br))
    concat(raw(podcast.footer))
  end
end
