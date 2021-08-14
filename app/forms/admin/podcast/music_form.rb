# frozen_string_literal: true

class Admin::Podcast::MusicForm < Tramway::Core::ApplicationForm
  properties :file, :music_type, :project_id

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        file: :file,
        music_type: :default
    end
  end
end
