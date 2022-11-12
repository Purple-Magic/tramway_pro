# frozen_string_literal: true

class Admin::Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :project_id, :file, :ready_file, :cover, :number, :public_title, :montage_process, :story_cover,
    :description, :full_video, :trailer_video, :trailer, :publish_date, :story_trailer_video

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        public_title: :string,
        description: :text,
        number: :numeric,
        publish_date: :date_picker,
        file: :file,
        ready_file: :file,
        cover: :file,
        story_cover: :file,
        montage_process: :default,
        trailer: :file,
        full_video: :file,
        trailer_video: :file,
        story_trailer_video: :file
    end
  end
end
