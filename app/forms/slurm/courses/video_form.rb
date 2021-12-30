# frozen_string_literal: true

class Slurm::Courses::VideoForm < Tramway::Core::ApplicationForm
  properties :text, :project_id, :position, :release_date, :duration

  association :lesson

  def initialize(object)
    super(object).tap do
      form_properties lesson: :association,
        text: :ckeditor,
        position: :numeric,
        release_date: :date_picker,
        duration: :string
    end
  end
end
