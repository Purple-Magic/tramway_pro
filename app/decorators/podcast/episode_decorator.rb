# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :highlights, as: :episode
  decorate_association :stars, as: :episode
  decorate_association :podcast
  decorate_association :topics, as: :episode
  decorate_association :links, as: :episode
  decorate_association :instances, as: :episode

  delegate_attributes :id, :number, :file_url, :montage_state

  include Podcast::Episodes::DescriptionConcern
  include Podcast::Episodes::DescriptionBuildConcern
  include Podcast::Episodes::VideoDecorator
  include Podcast::Episodes::SocialPostsConcern

  class << self
    def show_associations
      %i[highlights topics stars links instances]
    end

    def show_attributes
      %i[podcast_link number file ready_file premontage_file trailer cover trailer_video full_video 
         description_view youtube_description vk_post_text telegram_post_text instagram_post_text twitter_post_text montage_state]
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
    text = "Вы можете прослушать выпуск подкаста на этих площадках:<br/>"
    text += instances.map do |instance|
      "* #{instance.service.capitalize} #{instance.shortened_url}"
    end.join("<br/>")
    text += "<br/>"
    text += "<br/>"
    text += recursively_build_description(Nokogiri::HTML(description_view.html_safe).elements).gsub("\n", '<br/>')
    raw text
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

    case object.podcast.podcast_type.to_sym
    when :sample
      download_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :download)
      finish_record_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish_record)
      trailer_get_ready_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :trailer_get_ready)
      finish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish)
      publish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :publish)

      {
        show: [
          { url: download_url, method: :patch, inner: -> { 'Download' }, color: :success },
          { url: finish_record_url, method: :patch, inner: -> { 'Finish record' }, color: :success },
          { url: trailer_get_ready_url, method: :patch, inner: -> { 'Trailer get ready' }, color: :success },
          { url: finish_url, method: :patch, inner: -> { 'Finish' }, color: :success },
          { url: publish_url, method: :patch, inner: -> { 'Publish' }, color: :success }
        ]
      }
    when :handmade
      render_video_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :render_video)

      {
        show: [
          { url: render_video_url, method: :patch, inner: -> { 'Render video' }, color: :success },
        ]
      }
    end
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
