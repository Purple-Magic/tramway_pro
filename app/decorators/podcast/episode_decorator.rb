# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :highlights, :podcast, :topics, :stars, :links

  delegate_attributes :id, :number, :file_url, :montage_state

  include Podcast::Episodes::DescriptionConcern
  include Podcast::Episodes::DescriptionConcern

  class << self
    def show_associations
      %i[highlights topics stars links]
    end

    def show_attributes
      %i[podcast_link number file ready_file premontage_file trailer cover trailer_video full_video image mp3_file
         description description_view youtube_description montage_state]
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

  def youtube_description
    raw recursively_build_description(Nokogiri::HTML(description_view.html_safe).elements).gsub("\n", '<br/>')
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
