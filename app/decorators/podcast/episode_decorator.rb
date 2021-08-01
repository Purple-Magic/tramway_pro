# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :highlights

  delegate_attributes :number, :file_url, :montage_state

  class << self
    def show_associations
      [:highlights]
    end

    def show_attributes
      %i[title number file ready_file premontage_file cover video image mp3 description montage_state highlights_files]
    end
  end

  def title
    "Выпуск №#{object.number}"
  end

  def video
    path_helpers = Rails.application.routes.url_helpers
    path = path_helpers.red_magic_api_v1_podcast_episodes_video_path(object.id)
    link_to 'Download', path
  end

  def cover
    file_view object.cover
  end

  def image
    image_tag(object.image, style: 'height: 200px') if object.image.present?
  end

  def mp3
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
    file_view object.ready_file
  end

  def montage_file
    link_to 'Download', object.montage_file.url
  end

  def highlights_files
    parts = Dir["#{object.parts_directory_name}/part-*.mp3"]

    content_tag :table do
      parts.each do |part|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            short_name = part.split('/').last
            link_to short_name, "/#{part.split('/')[-4..].join('/')}"
          end)
        end)
      end
    end
  end

  def additional_buttons
    export_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(
      object.id,
      model: object.class,
      collection: :highlights
    )

    path_helpers = Rails.application.routes.url_helpers
    finish_record_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: object.id, process: :finish_record)
    prepare_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: object.id, process: :prepare)
    montage_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: object.id, process: :montage)
    finish_url = path_helpers.red_magic_api_v1_podcast_episode_path(id: object.id, process: :finish)
    download_all_parts = path_helpers.red_magic_api_v1_podcast_episodes_parts_path(id: object.id)
    video_generate_path = path_helpers.red_magic_api_v1_podcast_episodes_videos_path(id: object.id)

    {
      show: [
        { url: export_url, inner: -> { fa_icon 'file-excel' }, color: :success },
        { url: finish_record_url, method: :patch, inner: -> { 'Finish record' }, color: :success },
        { url: prepare_url, method: :patch, inner: -> { 'Prepare' }, color: :success },
        { url: montage_url, method: :patch, inner: -> { 'Montage' }, color: :success },
        { url: finish_url, method: :patch, inner: -> { 'Finish' }, color: :success },
        { url: download_all_parts, method: :get, inner: -> { fa_icon :download }, color: :success },
        { url: video_generate_path, method: :post, inner: -> { fa_icon :video }, color: :success }
      ]
    }
  end

  def montage_button_color(event); end

  def premontage_file
    file_view object.premontage_file
  end
end
