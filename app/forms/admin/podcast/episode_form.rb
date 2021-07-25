# frozen_string_literal: true

class Admin::Podcast::EpisodeForm < Tramway::Core::ApplicationForm
  properties :project_id, :file, :ready_file, :cover

  def initialize(object)
    super(object).tap do
      form_properties file: :file,
        ready_file: :file,
        cover: :file
    end
  end
end
