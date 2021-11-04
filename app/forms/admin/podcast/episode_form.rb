# frozen_string_literal: true

class Admin::Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :project_id, :file, :ready_file, :cover, :number, :public_title

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        public_title: :string,
        number: :numeric,
        file: :file,
        ready_file: :file,
        cover: :file
    end
  end
end
