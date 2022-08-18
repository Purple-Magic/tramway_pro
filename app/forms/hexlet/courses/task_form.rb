# frozen_string_literal: true

class Hexlet::Courses::TaskForm < Tramway::Core::ApplicationForm
  properties :position, :text, :max_time, :min_time, :project_id

  association :lesson

  def initialize(object)
    super(object).tap do
      form_properties lesson: :association,
        position: :integer,
        text: :ckeditor,
        min_time: :string,
        max_time: :string
    end
  end
end
