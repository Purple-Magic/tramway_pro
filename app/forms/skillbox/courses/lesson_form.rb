# frozen_string_literal: true

class Skillbox::Courses::LessonForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :position

  association :topic

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        topic: :association,
        position: :numeric
    end
  end
end
