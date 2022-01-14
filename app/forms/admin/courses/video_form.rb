# frozen_string_literal: true

class Admin::Courses::VideoForm < Tramway::Core::ApplicationForm
  properties :text, :project_id, :position, :release_date, :duration, :result_duration, :url

  association :lesson

  def initialize(object)
    super(object).tap do
      form_properties lesson: :association,
        text: :ckeditor,
        position: :numeric,
        release_date: :date_picker,
        duration: :string,
        result_duration: :string,
        url: :string
    end
  end
end
