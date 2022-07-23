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
    concat(content_tag(:ul) do
      object.stars.main.each do |star|
        concat(content_tag(:li) do
          concat link_to "@#{star.nickname}", star.link
        end)
      end
    end)
  end

  def guest_list
    concat('Гости:')
    concat(content_tag(:ul) do
      object.stars.guest.each do |star|
        concat(content_tag(:li) do
          concat link_to "@#{star.nickname}", star.link
        end)
      end
    end)
  end

  def minor_list
    concat('Эпизодическое участие:')
    concat(content_tag(:ul) do
      object.stars.minor.each do |star|
        concat(content_tag(:li) do
          concat link_to "@#{star.nickname}", star.link
        end)
      end
    end)
  end

  def topics_list
    concat(content_tag(:h1) do
      'Темы выпуска'
    end)
    if topics.any?
      concat(content_tag(:ul) do
        topics.each do |topic|
          concat(content_tag(:li) do
            concat link_to topic.title, topic.link
          end)
        end
      end)
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
      concat(content_tag(:li) do
        link_to link.title, link.link
      end)
    end
  end

  def static_content
    concat(content_tag(:br))
    concat(raw(podcast.footer))
  end
end
