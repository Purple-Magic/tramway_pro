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
    concat(content_tag(:ul) do
      topics.each do |topic|
        concat(content_tag(:li) do
          concat link_to topic.title, topic.link
        end)
      end
    end)
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
    crowd_sourcing_link
    social_networks
    music_link
    painter_link
  end

  def crowd_sourcing_link
    concat('Поддержи сообщество IT Way, чтобы мы делали кучу разного контента!')
    concat(link_to('Ссылка для поддержки', 'https://boosty.to/it_way_podcast'))
  end

  def social_networks
    concat(content_tag(:h1) do
      'Подписывайтесь на IT Way'
    end)
    links = {
      'ВКонтакте' => 'https://vk.com/it_way',
      'Чат в Telegram' => 'https://t.me/it_way_chat',
      'Youtube' => 'https://www.youtube.com/c/ITWay',
      'Twitter' => 'https://twitter.com/it_way_pro',
      'Instagram' => 'https://instagram.com/it_way.pro',
      'Комикс' => 'https://vk.com/asya_comics'
    }
    concat(content_tag(:ul) do
      links.each do |pair|
        concat(content_tag(:li) do
          link_to(*pair)
        end)
      end
    end)
  end

  def music_link
    concat(content_tag(:p) do
      concat 'Музыка: инструментал песни M.G. - Абсурд, студия '
      concat(link_to('ALPHA RECORDS', 'https://vk.com/alpharecords73'))
    end)
  end

  def painter_link
    concat(content_tag(:p) do
      concat 'Автор логотипа - художник '
      concat(link_to('Екатерина Нечаева', 'https://vk.com/kiborgvviborge'))
    end)
  end
end
