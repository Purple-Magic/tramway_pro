# frozen_string_literal: true

class Admin::PodcastForm < Tramway::Core::ApplicationForm
  properties :title, :feed_url, :default_image, :podcast_type, :footer, :youtube_footer, :chat_id, :url

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        feed_url: :string,
        default_image: :file,
        podcast_type: :default,
        footer: :ckeditor,
        youtube_footer: :text,
        chat_id: :string,
        url: :string
    end
  end
end
