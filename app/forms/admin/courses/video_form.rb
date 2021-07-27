# frozen_string_literal: true

class Admin::Courses::VideoForm < Tramway::Core::ApplicationForm
  properties :text, :project_id, :position

  association :lesson

  def initialize(object)
    super(object).tap do
      form_properties lesson: :association,
        text: :ckeditor,
        position: :numeric
    end
  end
end
