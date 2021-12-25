# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :highlights, as: :episode
  decorate_association :stars, as: :episode
  decorate_association :podcast
  decorate_association :topics, as: :episode
  decorate_association :links, as: :episode
  decorate_association :instances, as: :episode

  delegate_attributes :id, :number, :file_url, :montage_state, :public_title

  include Podcast::Episodes::DescriptionConcern
  include Podcast::Episodes::YoutubeDescriptionConcern
  include Podcast::Episodes::VideoDecorator
  include Podcast::Episodes::SocialPostsConcern

  class << self
    def show_associations
      %i[highlights topics stars links instances]
    end

    def show_attributes
      %i[podcast_link public_title number file ready_file premontage_file trailer cover trailer_video full_video
         description_view youtube_description vk_post_text telegram_post_text instagram_post_text twitter_post_text
         patreon_post_text montage_state]
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

    render_video_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :render_video)
    render_video_button = { url: render_video_url, method: :patch, inner: -> { fa_icon :video }, color: :success }

    case object.podcast.podcast_type.to_sym
    when :sample
      download_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :download)
      finish_record_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish_record)
      trailer_get_ready_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :trailer_get_ready)
      finish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish)
      render_video_trailer_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id,
        process: :render_video_trailer)
      publish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :publish)

      video_trailer_button_inner = content_tag(:span) do
        concat(fa_icon(:video))
        concat(' ')
        concat(fa_icon(:trailer))
      end

      {
        show: [
          { url: download_url, method: :patch, inner: -> { fa_icon :download }, color: :success },
          { url: finish_record_url, method: :patch, inner: -> { fa_icon :tools }, color: :success },
          { url: trailer_get_ready_url, method: :patch, inner: -> { fa_icon :trailer }, color: :success },
          { url: finish_url, method: :patch, inner: -> { fa_icon 'volume-up' }, color: :success },
          { url: render_video_trailer_url, method: :patch, inner: -> { video_trailer_button_inner }, color: :success },
          render_video_button,
          { url: publish_url, method: :patch, inner: -> { fa_icon :share }, color: :success }
        ]
      }
    when :handmade
      {
        show: [
          render_video_button
        ]
      }
    when :without_music
      finish_record_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish_record)
      finish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :finish)

      {
        show: [
          { url: finish_record_url, method: :patch, inner: -> { 'Finish record' }, color: :success },
          { url: finish_url, method: :patch, inner: -> { 'Finish' }, color: :success }
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
