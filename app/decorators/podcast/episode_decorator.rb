# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :highlights, :podcast, :topics, :stars

  delegate_attributes :id, :number, :file_url, :montage_state

  class << self
    def show_associations
      %i[highlights topics stars]
    end

    def show_attributes
      %i[podcast_link number file ready_file premontage_file trailer cover trailer_video full_video image mp3_file
         description description_view montage_state]
    end
  end

  def podcast_link
    link_to podcast.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.podcast_id, model: 'Podcast')
  end

  def title
    "Выпуск №#{object.number}"
  end

  def cover
    file_view object.cover
  end

  def trailer
    content_tag(:audio, controls: true) do
      content_tag(:source, '', src: object.trailer.url)
    end
  end

  def trailer_video
    content_tag(:video, controls: true, width: '400px') do
      content_tag(:source, '', src: object.trailer_video.url)
    end
  end

  def full_video
    content_tag(:video, controls: true, width: '400px') do
      content_tag(:source, '', src: object.full_video.url)
    end
  end

  def image
    image_tag(object.image, style: 'height: 200px') if object.image.present?
  end

  def mp3_file
    file_url = object.attributes['file_url']
    link_to file_url, file_url if file_url.present?
  end

  def description
    raw object.description
  end

  def description_view
    content_tag(:div) do
      concat('Ведущие:')
      concat(content_tag(:ul) do
        stars.each do |star|
          concat(content_tag(:li) do
            concat link_to star.nickname, star.link
          end)
        end
      end)
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
      concat('Поддержи сообщество IT Way, чтобы мы делали кучу разного контента!')
      concat(link_to('Ссылка для поддержки', 'https://boosty.to/it_way_podcast'))
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
            link_to *pair
          end)
        end
      end)
      concat(content_tag(:p) do
        concat 'Музыка: инструментал песни M.G. - Абсурд, студия '
        concat(link_to('ALPHA RECORDS', 'https://vk.com/alpharecords73'))
      end)
      concat(content_tag(:p) do
        concat 'Автор логотипа - художник '
        concat(link_to('Екатерина Нечаева', 'https://vk.com/kiborgvviborge'))
      end)
    end
  end

  def file
    file_view object.file
  end

  def ready_file
    content_tag(:audio, controls: true) do
      content_tag(:source, '', src: object.ready_file.url)
    end
  end

  def montage_file
    link_to 'Download', object.montage_file.url
  end

  def additional_buttons
    path_helpers = Rails.application.routes.url_helpers
    finish_record_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish_record)
    trailer_get_ready_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :trailer_get_ready)
    finish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish)

    {
      show: [
        { url: finish_record_url, method: :patch, inner: -> { 'Finish record' }, color: :success },
        { url: trailer_get_ready_url, method: :patch, inner: -> { 'Trailer get ready' }, color: :success },
        { url: finish_url, method: :patch, inner: -> { 'Finish' }, color: :success }
      ]
    }
  end

  def montage_button_color(_event)
    :success
  end

  def premontage_file
    content_tag(:audio, controls: true) do
      content_tag(:source, '', src: object.premontage_file.url)
    end
  end
end
