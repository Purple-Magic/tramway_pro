# frozen_string_literal: true

class Podcast::EpisodeDecorator < ApplicationDecorator
  decorate_association :parts, as: :episode
  decorate_association :highlights, as: :episode
  decorate_association :stars, as: :episode
  decorate_association :podcast
  decorate_association :topics, as: :episode
  decorate_association :links, as: :episode
  decorate_association :instances, as: :episode
  decorate_association :time_logs, as: :associated

  delegate_attributes :id, :number, :file_url, :montage_state, :public_title, :story_cover

  include Podcast::Episodes::DescriptionConcern
  include Podcast::Episodes::VideoDecorator
  include Podcast::Episodes::SocialPostsConcern

  class << self
    def show_associations
      %i[parts highlights topics stars links instances time_logs]
    end

    def show_attributes
      %i[render_commands podcast_link public_title file ready_file premontage_file trailer cover story_cover trailer_video story_trailer_video full_video
         description_view youtube_description vk_post_text telegram_post_text instagram_post_text twitter_post_text
         patreon_post_text montage_state]
    end
  end

  def render_commands
    content_tag(:div) do
      concat(content_tag(:button, type: :button, class: 'btn btn-primary',
data: { toggle: :collapse, target: '#commands' }, aria: { controls: :commands }) do
               concat(content_tag(:span) do
                 'Раскрыть '
               end)
               concat fa_icon('caret-down')
             end)
      concat(content_tag(:div, class: :collapse, id: :commands) do
        concat content_tag :hr
        concat(content_tag(:ul) do
          object.render_data&.dig('commands')&.each do |command|
            concat(content_tag(:li) do
              command
            end)
          end
        end)
      end)
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

  def story_cover
    file_view object.story_cover
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
    # FIXME sending self as argument is not a good point
    raw Podcasts::Youtube::DescriptionBuilder.new(self, format: :html).call
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

  def listed_state_machines
    []
  end

  def additional_buttons
    path_helpers = Rails.application.routes.url_helpers

    render_video_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: id, process: :render_video)
    render_video_button = { url: render_video_url, method: :patch, inner: -> { fa_icon :video }, color: :success }

    case object.podcast.podcast_type.to_sym
    when :sample, :without_music
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
