class VideoDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :url,
        :created_at,
        :updated_at,
  )

  class << self
    def collections
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :url,
        :created_at,
        :updated_at,
      ]
    end

    def show_attributes
      [
        :preview,
        :link,
        :created_at,
        :updated_at,
      ]
    end
  end

  def title
    "Video #{object.id}"
  end

  def preview
  end

  def link
    link_to object.url, object.url
  end
end
