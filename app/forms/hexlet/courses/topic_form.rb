# frozen_string_literal: true

class Hexlet::Courses::TopicForm < Tramway::ApplicationForm
  properties :title, :state, :project_id, :position

  association :course

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        course: :association,
        position: :numeric
    end
  end
end
