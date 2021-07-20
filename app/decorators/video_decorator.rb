# frozen_string_literal: true

class VideoDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
    :id,
    :url,
    :created_at,
    :updated_at
  )

  class << self
    def collections
      [:all]
    end

    def list_attributes
      %i[
        id
        url
        created_at
        updated_at
      ]
    end

    def show_attributes
      %i[
        preview
        link
        description
        created_at
        updated_at
      ]
    end
  end

  def title
    "Video #{object.id}"
  end

  def description
    raw object.description
  end

  def preview
    image_tag object.preview if object.preview.present?
  end

  def link
    link_to object.url, object.url
  end
end
