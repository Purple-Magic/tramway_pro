# frozen_string_literal: true

class Hexlet::CourseForm < Tramway::ApplicationForm
  properties :title, :project_id, :team

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        team: :default
    end
  end
end
