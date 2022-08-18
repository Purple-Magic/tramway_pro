# frozen_string_literal: true

class Admin::Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :project_id, :file, :ready_file, :cover, :number, :public_title, :montage_process, :story_cover,
    :description, :full_video

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        public_title: :string,
        description: :text,
        number: :numeric,
        file: :file,
        ready_file: :file,
        cover: :file,
        story_cover: :file,
        montage_process: :default,
        full_video: :file
    end
  end
end
